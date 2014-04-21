//
//  ITPPickerTableViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewController.h"
#import "ITPPickerTableViewCell.h"

@interface ITPPickerTableViewController() <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
    @property (nonatomic,readonly) NSArray* ds;
    @property (nonatomic,strong) NSString* country;
    @property (nonatomic,assign) NSInteger indexSelected;
    @property (nonatomic,strong) ACKITunesQuery* query;
    @property (nonatomic,assign) BOOL filterCountry;
    @property (nonatomic,assign) BOOL loadWithArtistId;
@end

@implementation ITPPickerTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.indexSelected = NSNotFound;
        self.filterCountry = YES;
        self.query = [[ACKITunesQuery alloc]init];
        self.query.cachePolicyChart = NSURLRequestUseProtocolCachePolicy;
        self.query.cachePolicyLoadEntity = NSURLRequestUseProtocolCachePolicy;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)dealloc
{
    self.delegate = nil;
}

#pragma mark Action

- (IBAction)previousAction:(id)sender {
    if(![self.delegate respondsToSelector:@selector(showPickerAtIndex:)])
    {
        return;
    }
    [self.delegate showPickerAtIndex:[self pickerIndex]-1];
}

- (IBAction)nextAction:(id)sender {
    if(![self.delegate respondsToSelector:@selector(showPickerAtIndex:)])
    {
        return;
    }
    
    [self.delegate showPickerAtIndex:[self pickerIndex]+1];
}

- (IBAction)countryAction:(id)sender {
    if([self.country isEqual:[self.delegate entitiesDatasources].userCountry])
    {
       return;
    }
    self.filterCountry = !self.filterCountry;
    [self.tableView reloadData];
}

#pragma mark public

-(void) loadChartInITunesStoreCountry:(NSString*)country withType:(tITunesAppChartType)type withGenre:(tITunesAppGenreType)genre completionBlock:(ACKArrayResultBlock)completion
{
    self.loading = YES;
    self.filterCountry = ![country isEqualToString:[self.delegate entitiesDatasources].userCountry];
    
    self.itemsFounded = nil;
    NSInteger limit = [self.delegate entitiesDatasources].limit;
    _country = country;
    
    NSInteger datasourceIndex = [[self.delegate entitiesDatasources]getDatasourceIndexForCountry:country];
    if(datasourceIndex == NSNotFound)
    {
        //reserve ds index
        datasourceIndex = [[self.delegate entitiesDatasources]addDatasource:[[NSArray alloc]init] foriTunesCountry:country];
    }
    [self updateUI];
    
    [self.query loadAppChartInITunesStoreCountry:country withType:type withGenre:genre limit:limit completionBlock:^(NSArray *array, NSError *err) {
        if(!err)
        {
            [[self.delegate entitiesDatasources] replaceDatasourceAtIndex:datasourceIndex entity:array foriTunesCountry:country];
            [self loadExistEntitiesInUserCountry:completion];
        }
        else{
            self.loading = NO;
            [self updateUI];
            if(completion)
            {
                completion(array,err);
            }
        }
    }];
}

-(void) loadEntitiesForArtistId:(NSString *)artistId inAppStoreCountry:(NSString*)country withType:(tITunesEntityType)type completionBlock:(ACKArrayResultBlock)completion
{
    self.loading = YES;
    self.filterCountry = ![country isEqualToString:[self.delegate entitiesDatasources].userCountry];
    
    self.itemsFounded = nil;
    _country = country;
    
    NSInteger datasourceIndex = [[self.delegate entitiesDatasources]getDatasourceIndexForCountry:country];
    if(datasourceIndex == NSNotFound)
    {
        //reserve ds index
        datasourceIndex = [[self.delegate entitiesDatasources]addDatasource:[[NSArray alloc]init] foriTunesCountry:country];
    }
    [self updateUI];
    
    self.loadWithArtistId = YES;
    
    [self.query loadEntitiesForArtistId:artistId inAppStoreCountry:country withType:type completionBlock:^(NSArray *array, NSError *err) {
        if(!err)
        {
            [[self.delegate entitiesDatasources] replaceDatasourceAtIndex:datasourceIndex entity:array foriTunesCountry:country];
            [self loadExistEntitiesInUserCountry:completion];
        }
        else{
            self.loading = NO;
            [self updateUI];
            if(completion)
            {
                completion(array,err);
            }
        }
    }];
}

-(void) selectEnityAtIndex:(NSInteger)index
{
    if(self.indexSelected == index)
    {
        self.indexSelected = NSNotFound;
    }
    else
    {
        self.indexSelected = index;
    }
    [self.tableView reloadData];
    if(index != NSNotFound)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ITPPickerTableViewCell";
    ITPPickerTableViewCell *cell = (ITPPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ITPPickerTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.appObject = [self.ds objectAtIndex:indexPath.row];
    cell.userCountry = [self.delegate entitiesDatasources].userCountry;
    if(self.itemsFounded || self.loadWithArtistId)
    {
        cell.positionLabel.text = @"";
    }
    else{
        cell.positionLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    }
    
    cell.detailButton.hidden = ![self.delegate respondsToSelector:@selector(openITunesEntityDetail:pickerCountry:)];
    
    return cell;
}

#pragma mark- Table view delegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    
    BOOL exists = [((NSNumber*)[self.existsItemsInUserCountry objectAtIndex:indexPath.row]) boolValue];
    if(self.existsItemsInUserCountry.count == [self ds].count && !exists)
    {
        cell.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:0.5];
    }
    if(self.filterCountry)
    {
        NSArray* dsUser = [[self.delegate entitiesDatasources]getDatasourceForCountry:[self.delegate entitiesDatasources].userCountry];
        for (ACKITunesEntity* ent in dsUser) {
            if([ent isEqualToEntity:[self.ds objectAtIndex:indexPath.row]])
            {
                cell.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:0.5];
                break;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(![self.delegate respondsToSelector:@selector(openITunesEntityDetail:pickerCountry:)])
    {
        return;
    }
    if (indexPath.row < self.ds.count) {
        ACKITunesEntity* entity = self.ds[indexPath.row];
        BOOL exists = [((NSNumber*)[self.existsItemsInUserCountry objectAtIndex:indexPath.row]) boolValue];
        if(exists && ![self.country isEqual:[self.delegate entitiesDatasources].userCountry])
        {
            [self.query loadEntity:entity inITunesStoreCountry:[self.delegate entitiesDatasources].userCountry completionBlock:^(ACKITunesEntity *ent, NSError *err) {
                if(!err)
                {
                    [self.delegate openITunesEntityDetail:ent pickerCountry:self.country];
                }
                else
                {
                    [self.delegate openITunesEntityDetail:entity pickerCountry:self.country];
                }
            }];
        }
        else
        {
            [self.delegate openITunesEntityDetail:entity pickerCountry:self.country];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![self.delegate respondsToSelector:@selector(selectEntity:)])
    {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ACKITunesEntity* entity = self.ds[indexPath.row];
    [self.delegate selectEntity:entity];
}



#pragma mark UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(text.length > 0)
    {
        [self setLoading:YES];
        tITunesEntityType entityType = [self.delegate entitiesDatasources].entityType;
        NSInteger limit = [self.delegate entitiesDatasources].limit;
        [self.query searchEntitiesForTerms:text inITunesStoreCountry:self.country withType:entityType limit:limit completionBlock:^(NSArray *array, NSError *err) {
            if(!err)
            {
                self.itemsFounded = array;
            }
            else{
                self.itemsFounded = nil;
            }
            [self.tableView reloadData];
            [self setLoading:NO];
        }];
    }
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSString* text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(text.length == 0)
    {
        self.itemsFounded = nil;
    }
    [self.tableView setUserInteractionEnabled:YES];
    [self.tableView reloadData];
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView setUserInteractionEnabled:NO];
    return YES;
}

#pragma mark private

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchBar isFirstResponder] && [touch view] != self.searchBar)
    {
        [self.searchBar resignFirstResponder];
        [self.tableView setUserInteractionEnabled:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

-(NSArray*)ds
{
    if(self.itemsFounded)
    {
       return self.itemsFounded;
    }
    return [[self.delegate entitiesDatasources]getDatasourceAtIndex:[self pickerIndex]];
}

-(NSInteger)pickerIndex
{
    return [[[self.delegate entitiesDatasources]getAllCountries] indexOfObject:self.country];
}

-(void)setLoading:(BOOL)loading
{
    _loading = loading;
    if(![self.delegate respondsToSelector:@selector(showLoadingHUD:)])
    {
        return;
    }
    [self.delegate showLoadingHUD:loading];
}

-(void) updateUI
{
    NSLocale* currentLocale = [NSLocale currentLocale];
    self.countryImageView.image = [UIImage imageNamed:self.country];
    [self.countryButton setTitle:[currentLocale displayNameForKey:NSLocaleCountryCode value:self.country] forState:UIControlStateNormal];
    
    NSInteger datasourceIndex = [self pickerIndex];
    self.previousButton.enabled = !self.loading && datasourceIndex != NSNotFound && datasourceIndex > 0;
    self.nextButton.enabled = !self.loading && datasourceIndex != NSNotFound && datasourceIndex < [self.delegate entitiesDatasources].datasourcesCount-1;
    [self.tableView reloadData];
    
    if(![self.delegate respondsToSelector:@selector(showPickerAtIndex:)])
    {
        self.previousButton.hidden = YES;
        self.nextButton.hidden = YES;
    }
    
    if(self.loadWithArtistId && !self.searchBar.hidden)
    {
        self.searchBar.hidden = YES;
        UIView *headerView = [[UIView alloc] initWithFrame:self.searchBar.bounds];
        UILabel *labelView = [[UILabel alloc] initWithFrame:self.searchBar.bounds];
        labelView.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:labelView];
        ACKITunesEntity* ent = [self.ds objectAtIndex:0];
        if(ent.iTunesEntityType == kITunesEntityTypeSoftware)
        {
           labelView.text = ((ACKApp*)ent).artistName;
        }
        self.tableView.tableHeaderView = headerView;
    }
}

-(void) loadExistEntitiesInUserCountry:(ACKArrayResultBlock)completion
{
    self.loading = YES;
    
    tITunesEntityType entityType = [self.delegate entitiesDatasources].entityType;
    [self.query existsEntities:self.ds inITunesStoreCountry:[self.delegate entitiesDatasources].userCountry withType:entityType completionBlock:^(NSArray *array, NSError *err) {
        if(!err)
        {
            self.existsItemsInUserCountry = array;
        }
        
        self.loading = NO;
        
        [self updateUI];
        if(completion)
        {
            completion(array,err);
        }
    }];
}

@end
