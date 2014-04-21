//
//  ITPViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPViewController.h"
#import "ITPPickerTableViewController.h"

#import "SwipeView.h"
#import "ITPCountryItemChartsViewController.h"
#import "IPTMenuTableViewController.h"
#import "ITPPickerDetailViewController.h"
#import "SVProgressHUD.h"

@interface ITPViewController () <SwipeViewDataSource, SwipeViewDelegate, IPTMenuTableViewDelegate>
{
    CGRect filterCloseFrame,filterOpenFrame;
    tITunesAppChartType rankingSelectedIndex;
    tITunesAppGenreType genreSelectedIndex;
    BOOL pickersLoading;
    BOOL firstLoad;
}

@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (nonatomic, strong) IPTMenuTableViewController *leftPanel;
@property (nonatomic, strong) IPTMenuTableViewController *rightPanel;

@end

@implementation ITPViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UINib *nib = [UINib nibWithNibName:@"ITPViewController" bundle:nil];
        NSArray *nibObjects = [nib instantiateWithOwner:self options:nil];
        self.view = nibObjects.lastObject;
        
        filterOpenFrame = self.filterView.frame;
        filterCloseFrame = filterOpenFrame;
        filterCloseFrame.origin.y -= self.filterView.frame.size.height;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMenuPanels];
    
    pickersLoading = NO;
    firstLoad = YES;
    _swipeView.pagingEnabled = YES;
    
    UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"filter.png"] style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(filterAction:)];
    self.navigationItem.rightBarButtonItem = filterBarButtonItem;
    
    [self.countryButton setImage:[UIImage imageNamed:@"globe.png"] forState:UIControlStateNormal];
    self.pickerViews = [[NSMutableArray alloc]init];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"save_picker_state"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(firstLoad)
    {
        firstLoad = NO;
        [self loadPickerState];
        if(!self.entitiesDatasources)
        {
            [self openUserCountryPicker:nil];
        }
    }
}

- (void)dealloc
{
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
}

#pragma mark Action

- (IBAction)filterAction:(id)sender {
    [self toggleFilterPanelWithCompletionBlock:^(BOOL isOpen) {
    }];
}

- (IBAction)countryAction:(id)sender {
    [self closeAllPanelsExcept:nil];
    ITPCountryItemChartsViewController *vc = [[ITPCountryItemChartsViewController alloc] initWithStyle:UITableViewStylePlain
                                                                                          allCountries:[ACKITunesQuery getITunesStoreCountries]
                                                                                     selectedCountries:[[NSSet alloc]initWithArray:[self.entitiesDatasources getAllCountries]]
                                                                                           userCountry:self.entitiesDatasources.userCountry
                                                                                           multiSelect:YES];
    vc.completionBlock = ^(NSArray *countries){
        NSArray* allPickerCountries = [[self.entitiesDatasources getAllCountries] copy];
        for (NSString* countryPicker in allPickerCountries) {
            if(![countries containsObject:countryPicker])
            {
                [self removePickerTableViewForCountry:countryPicker];
            }
        }
        for (NSString* country in countries) {
            if(![allPickerCountries containsObject:country])
            {
                [self addPickerTableViewForCountry:country];
            }
        }
        [self saveStatePickerApps];
        [_swipeView reloadData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)filterSxAction:(id)sender {
    [self toggleMenuPanel:sender];
}

- (IBAction)filterDxAction:(id)sender {
    [self toggleMenuPanel:sender];
}

- (IBAction)previousAction:(id)sender {
}

- (IBAction)openUserCountryPicker:(id)sender {
    ITPCountryItemChartsViewController *vc = [[ITPCountryItemChartsViewController alloc] initWithStyle:UITableViewStylePlain
                                                                                          allCountries:[ACKITunesQuery getITunesStoreCountries]
                                                                                     selectedCountries:nil
                                                                                           userCountry:[NSLocale preferredLanguages][0]
                                                                                       multiSelect:NO];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.title=NSLocalizedString(@"Select your iTunes Country",nil);
    vc.completionBlock = ^(NSArray *countries){
        [navigation dismissViewControllerAnimated:YES completion:NO];
        if(self.entitiesDatasources)
        {
            NSArray* allPickerCountries = [[self.entitiesDatasources getAllCountries] copy];
            for (NSString* countryPicker in allPickerCountries) {
                [self removePickerTableViewForCountry:countryPicker];
            }
        }
        self.entitiesDatasources = [[ACKEntitiesContainer alloc]initWithUserCountry:countries[0] entityType:kITunesEntityTypeSoftware limit:kITunesMaxLimitLoadEntities];
        [self addPickerTableViewForCountry:countries[0]];
        [self saveStatePickerApps];
        [self updateCountryBarButtonImage];
        [_swipeView reloadData];
    };
    
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark ITPViewControllerDelegate

-(void)showPickerAtIndex:(NSInteger)index
{
    [_swipeView scrollToItemAtIndex:index duration:0.5];
}

-(void)selectEntity:(ACKITunesEntity*)entity
{
    NSArray* indexCharts = [self.entitiesDatasources getIndexesFromEntity:entity];
    
    BOOL indexFound = NO;
    for (NSNumber* index in indexCharts) {
        NSInteger position = [index integerValue];
        if(position != NSNotFound)
        {
            indexFound = YES;
            break;
        }
    }
    
    if(!indexFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"App not in rankings",nil) message:NSLocalizedString(@"The selected App is not present in the rankings of countries loaded.",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Cancel",nil), nil];
        [alert show];
        return;
    }
    
    ITPCountryItemChartsViewController *vc = [[ITPCountryItemChartsViewController alloc] initWithStyle:UITableViewStylePlain
                                                                                          allCountries:[self.entitiesDatasources getAllCountries]
                                                                                           indexCharts:indexCharts
                                                                                                  item:entity];
    vc.completionBlock = ^(NSArray *countries){
//        if(countries.count > 0){
//            NSString* selectedCountry = countries[0];
//            NSInteger index = [self.entitiesDatasources getDatasourceIndexForCountry:selectedCountry];
//            if(index != NSNotFound && [((NSNumber*)indexCharts[index]) intValue] != NSNotFound)
//            {
//                ITPPickerTableViewController* picker = self.pickerViews[index];
//                [picker selectEnityAtIndex:[((NSNumber*)indexCharts[index]) intValue]];
//                [self showPickerAtIndex:index];
//            }
//        }
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)openITunesEntityDetail:(ACKITunesEntity*)entity pickerCountry:(NSString*)pickerCountry
{
    if([entity isKindOfClass:[ACKApp class]]){
        ITPPickerDetailViewController* detailController = [[ITPPickerDetailViewController alloc]initWithNibName:nil bundle:nil];
        detailController.appObject = (ACKApp*)entity;
        detailController.pickerCountry = pickerCountry;
        detailController.delegate = self;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

#pragma mark SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return  self.entitiesDatasources.datasourcesCount;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    ITPPickerTableViewController* picker = (ITPPickerTableViewController*)self.pickerViews[index];
    return picker.view;
}

#pragma mark SwipeViewDelegate

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    ITPPickerTableViewController* picker = ((ITPPickerTableViewController*)self.pickerViews[index]);
    [picker.searchBar resignFirstResponder];
}

-(void)showLoadingHUD:(BOOL)loading
{
    if(pickersLoading == loading)
    {
        return;
    }
    
    BOOL tmpPickersLoading = NO;
    for (ITPPickerTableViewController* pickerTableView in self.pickerViews) {
        tmpPickersLoading = tmpPickersLoading || pickerTableView.loading;
    }
    
    if(tmpPickersLoading == pickersLoading)
    {
        return;
    }
    
    pickersLoading = tmpPickersLoading;
    if(pickersLoading)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

#pragma mark private

-(ITPPickerTableViewController*) addPickerTableViewForCountry:(NSString*)country
{
    ITPPickerTableViewController* pickerTableView = [[ITPPickerTableViewController alloc]initWithNibName:nil bundle:nil];
    pickerTableView.delegate = self;
    [self.pickerViews addObject:pickerTableView];
    
    [pickerTableView loadChartInITunesStoreCountry:country withType:rankingSelectedIndex withGenre:genreSelectedIndex completionBlock:^(NSArray *array, NSError *err) {
        [_swipeView reloadData];
    }];
    
    return pickerTableView;
}

-(void) refreshAllPickers
{
    NSInteger i = 0;
    for (ITPPickerTableViewController* pickerTableView in self.pickerViews) {
        [pickerTableView loadChartInITunesStoreCountry:[self.entitiesDatasources getAllCountries][i] withType:rankingSelectedIndex withGenre:genreSelectedIndex completionBlock:^(NSArray *array, NSError *err) {
            [_swipeView reloadData];
        }];
        i++;
    }
}

-(void) removePickerTableViewForCountry:(NSString*)country
{
    NSInteger index = [[self.entitiesDatasources getAllCountries]indexOfObject:country];
    if(index ==  NSNotFound)
    {
        return;
    }
    [self.entitiesDatasources removeDatasourceAtIndex:index];
    [self.pickerViews removeObjectAtIndex:index];
    [_swipeView reloadData];
}

-(void)toggleFilterPanelWithCompletionBlock:(void (^)(BOOL isOpen))completion
{
    if(self.filterView.hidden)
    {
        self.filterView.frame = filterCloseFrame;
    }
    BOOL hide = !self.filterView.hidden;
    [UIView animateWithDuration:0.4 animations:^{
        if(!self.filterView.hidden){
            self.filterView.frame = filterCloseFrame;
            [self closeAllPanelsExcept:nil];
        }
        else
        {
            ITPPickerTableViewController* picker = (ITPPickerTableViewController*)self.pickerViews[self.swipeView.currentItemIndex];
            [picker.searchBar resignFirstResponder];
            self.filterView.hidden = NO;
            self.filterView.frame = filterOpenFrame;
        }
    } completion:^(BOOL finished) {
        self.filterView.hidden = hide;
        if(completion)
        {
            completion(!self.filterView.hidden);
        }
    }];
}

-(void)setupMenuPanels
{
    CGRect frame = self.swipeView.frame;
    frame.origin.y += self.filterView.frame.size.height;
    frame.size.height -= self.filterView.frame.size.height;
    
    self.leftPanel = [[IPTMenuTableViewController alloc]initWithNibName:nil bundle:nil];
    self.leftPanel.type = kPAPMenuPickerTypeRanking;
    self.leftPanel.openDirection = kPAPMenuOpenDirectionRight;
    self.leftPanel.items = [ACKITunesQuery getAppChartType];
    self.leftPanel.delegate = self;
    [self.view insertSubview:self.leftPanel.view belowSubview:self.filterView];
    self.leftPanel.openFrame = frame;
    self.leftPanel.backgroundAreaDismissRect = self.swipeView.frame;
    
    self.rightPanel = [[IPTMenuTableViewController alloc]initWithNibName:nil bundle:nil];
    self.rightPanel.type = kPAPMenuPickerTypeGenre;
    self.rightPanel.openDirection = kPAPMenuOpenDirectionLeft;
    self.rightPanel.items = [ACKITunesQuery getAppGenreType];

    self.rightPanel.delegate = self;
    [self.view insertSubview:self.rightPanel.view belowSubview:self.filterView];

    self.rightPanel.openFrame = frame;
    self.rightPanel.backgroundAreaDismissRect = self.swipeView.frame;
}

-(void)valueSelectedAtIndex:(NSInteger)index forType:(tPAPMenuPickerType)type refreshPickers:(BOOL)refresh
{
    switch (type) {
        case kPAPMenuPickerTypeRanking:
            rankingSelectedIndex = index;
            [self.filterSxButton setTitle: NSLocalizedString(self.leftPanel.items[rankingSelectedIndex],@"") forState: UIControlStateNormal];
            if(self.leftPanel.isOpen)
                [self toggleMenuPanel:self.filterSxButton];
            [self.leftPanel.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            break;
        case kPAPMenuPickerTypeGenre:
            genreSelectedIndex = index;
            [self.filterDxButton setTitle:NSLocalizedString(self.rightPanel.items[genreSelectedIndex],@"") forState: UIControlStateNormal];
            if(self.rightPanel.isOpen)
                [self toggleMenuPanel:self.filterDxButton];
            [self.rightPanel.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            break;
    }
    if(refresh)
    {
        [self saveStatePickerApps];
        [self refreshAllPickers];
    }
}

- (void)toggleMenuPanel:(id)sender
{
    if(sender == self.filterSxButton)
    {
        [self closeAllPanelsExcept:self.leftPanel];
        [self.leftPanel togglePanelWithCompletionBlock:^(BOOL isOpen) {
        }];
    }
    else if(sender == self.filterDxButton)
    {
        [self closeAllPanelsExcept:self.rightPanel];
        [self.rightPanel togglePanelWithCompletionBlock:^(BOOL isOpen) {
        }];
    }
}

-(void) closeAllPanelsExcept:(IPTMenuTableViewController*)panel
{
    if(panel != self.leftPanel && self.leftPanel.isOpen)
        [self.leftPanel togglePanelWithCompletionBlock:^(BOOL isOpen) {
        }];
    if(panel != self.rightPanel && self.rightPanel.isOpen)
        [self.rightPanel togglePanelWithCompletionBlock:^(BOOL isOpen) {
        }];
}

-(void)loadPickerState
{
    NSDictionary *defaultUserDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithInteger:-1], @"saved_picker_ranking",
                                         [NSNumber numberWithInteger:-1], @"saved_picker_genre",
                                         [[NSArray alloc]init], @"saved_picker_countries",
                                         @"", @"saved_picker_usercountry",
                                         nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultUserDefaults];
    
    BOOL loadDefault = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"save_picker_state"])
    {
        NSInteger ranking = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_picker_ranking"];
        NSInteger genre = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_picker_genre"];
        NSArray* countries = [[NSUserDefaults standardUserDefaults] arrayForKey:@"saved_picker_countries"];
        NSString* userCountry = [[NSUserDefaults standardUserDefaults] stringForKey:@"saved_picker_usercountry"];
        
        if(ranking != -1 && genre != -1 && countries.count > 0)
        {
            self.entitiesDatasources = [[ACKEntitiesContainer alloc]initWithUserCountry:userCountry entityType:kITunesEntityTypeSoftware limit:kITunesMaxLimitLoadEntities];
            [self valueSelectedAtIndex:ranking forType:kPAPMenuPickerTypeRanking refreshPickers:NO];
            [self valueSelectedAtIndex:genre forType:kPAPMenuPickerTypeGenre refreshPickers:NO];
            for (NSString* country in countries) {
                [self addPickerTableViewForCountry:country];
            }
            loadDefault = NO;
        }
    }
    if(loadDefault)
    {
        [self valueSelectedAtIndex:kITunesAppChartTypeTopFreeApps forType:kPAPMenuPickerTypeRanking refreshPickers:NO];
        [self valueSelectedAtIndex:kITunesAppGenreTypeAll forType:kPAPMenuPickerTypeGenre refreshPickers:NO];
    }
    else
    {
        [self updateCountryBarButtonImage];
        [_swipeView reloadData];
    }
}

-(void)saveStatePickerApps
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"save_picker_state"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:rankingSelectedIndex forKey:@"saved_picker_ranking"];
        [[NSUserDefaults standardUserDefaults] setInteger:genreSelectedIndex forKey:@"saved_picker_genre"];
        [[NSUserDefaults standardUserDefaults] setValue:[self.entitiesDatasources getAllCountries] forKey:@"saved_picker_countries"];
        [[NSUserDefaults standardUserDefaults] setValue:self.entitiesDatasources.userCountry forKey:@"saved_picker_usercountry"];
    }
}

-(void)updateCountryBarButtonImage
{
    UIBarButtonItem *userCountryBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithImage:[[UIImage imageNamed:self.entitiesDatasources.userCountry] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(openUserCountryPicker:)];
    self.navigationItem.leftBarButtonItem = userCountryBarButtonItem;
}

@end
