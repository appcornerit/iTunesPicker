//
//  ITPPickerTableViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewController.h"
#import "ITPAppPickerTableViewCell.h"
#import "ITPAudioPickerTableViewCell.h"
#import "ITPVideoPickerTableViewCell.h"
#import "ITPBookPickerTableViewCell.h"
#import "ITPMusicVideoPickerTableViewCell.h"
#import "ITPGraphic.h"
#import "ITPViewController.h"
#import "Chameleon.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ITPAppDelegate.h"
#import "ITPYouTubeViewController.h"
#import <StoreKit/StoreKit.h>

@interface ITPPickerTableViewController() <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, ACKTrackMusicVideoPlayerDelegate, SWTableViewCellDelegate, UIActionSheetDelegate>
    @property (nonatomic,readonly) NSArray* ds;
    @property (nonatomic,assign) NSInteger indexSelected;
    @property (nonatomic,strong) ACKITunesQuery* query;
    @property (nonatomic,assign) BOOL highlightCells;
    @property (nonatomic,assign) NSUInteger chartType;
    @property (nonatomic,assign) NSUInteger genreType;
    @property (nonatomic,assign) BOOL mustScrollContent;
    @property (nonatomic,strong) MPMoviePlayerViewController* moviePlayerController;
@end

@implementation ITPPickerTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.indexSelected = NSNotFound;
        self.highlightCells = YES;
        self.query = [[ACKITunesQuery alloc]init];
        self.query.cachePolicyChart = NSURLRequestReloadIgnoringCacheData;
        self.query.cachePolicyLoadEntity = NSURLRequestUseProtocolCachePolicy;
        self.mustScrollContent = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.cellZoomInitialAlpha = [NSNumber numberWithFloat:0.5];
    self.cellZoomAnimationDuration = [NSNumber numberWithFloat:0.3];
    self.cellZoomXScaleFactor = [NSNumber numberWithFloat:0.9];
    self.cellZoomYScaleFactor = [NSNumber numberWithFloat:0.9];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
    if(_loadState == kITPLoadStateRanking && self.mustScrollContent)
    {
        self.mustScrollContent = NO;
        self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
    }
}
- (void)dealloc
{
    self.delegate = nil;
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
}

#pragma mark public

-(void) loadChartInITunesStoreCountry:(NSString*)country withType:(NSUInteger)type withGenre:(NSUInteger)genre completionBlock:(ACKArrayResultBlock)completion
{
    self.chartType = type;
    self.genreType = genre;
    self.loading = YES;
    self.highlightCells = ![country isEqualToString:[self.delegate entitiesDatasources].userCountry];
    
    _loadState = kITPLoadStateRanking;
    
    _itemsArray = nil;
    NSInteger limit = [[NSUserDefaults standardUserDefaults] integerForKey:DEFAULT_ACK_CHART_ITEMS_KEY];
    _country = country;
    
    NSInteger datasourceIndex = [[self.delegate entitiesDatasources]getDatasourceIndexForCountry:country];
    if(datasourceIndex == NSNotFound)
    {
        //reserve ds index
        datasourceIndex = [[self.delegate entitiesDatasources]addDatasource:[[NSArray alloc]init] foriTunesCountry:country];
    }
    [self updateUI];
    
    
   void (^completionBlock)(NSArray *array, NSError *err) = ^(NSArray *array, NSError *err){
        if(!err)
        {
            [[self.delegate entitiesDatasources] replaceDatasourceAtIndex:datasourceIndex entity:array foriTunesCountry:country];
        }
        self.loading = NO;
        self.mustScrollContent = YES;
        [self updateUI];
        if(completion)
        {
            completion(array,err);
        }
    };
    
    self.query.userCountry = self.delegate.entitiesDatasources.userCountry;
    self.query.priority = [self.delegate getLoadingPriority:self];
    
    if(self.delegate.entitiesDatasources.entityType == kITunesEntityTypeSoftware)
    {
        [self.query loadAppChartInITunesStoreCountry:country withMediaType:self.delegate.entitiesDatasources.mediaEntityType withType:type withGenre:genre limit:limit completionBlock:completionBlock];
    }
    else if(self.delegate.entitiesDatasources.entityType == kITunesEntityTypeMusic)
    {
        [self.query loadMusicChartInITunesStoreCountry:country withType:type withGenre:genre explicit:YES limit:limit completionBlock:completionBlock];
    }
    else if(self.delegate.entitiesDatasources.entityType == kITunesEntityTypeMovie)
    {
        [self.query loadMovieChartInITunesStoreCountry:country withType:type withGenre:genre limit:limit completionBlock:completionBlock];
    }
    else if(self.delegate.entitiesDatasources.entityType == kITunesEntityTypeEBook)
    {
        [self.query loadBookChartInITunesStoreCountry:country withType:type withGenre:genre limit:limit completionBlock:completionBlock];
    }
    else if(self.delegate.entitiesDatasources.entityType == kITunesEntityTypeMusicVideo)
    {
        [self.query loadMusicVideosChartInITunesStoreCountry:country withType:type withGenre:genre explicit:YES limit:limit completionBlock:completionBlock];
    }
    else
    {
        [self.query loadAppChartInITunesStoreCountry:country withMediaType:self.delegate.entitiesDatasources.mediaEntityType withType:type withGenre:genre limit:limit completionBlock:completionBlock];
    }
}

-(void) loadEntitiesForArtistId:(NSString *)artistId inITunesCountry:(NSString*)country withType:(tITunesEntityType)type completionBlock:(ACKArrayResultBlock)completion
{
    self.loading = YES;
    self.highlightCells = ![country isEqualToString:[self.delegate entitiesDatasources].userCountry];
    
    _itemsArray = nil;
    _country = country;
    
    NSInteger datasourceIndex = [[self.delegate entitiesDatasources]getDatasourceIndexForCountry:country];
    if(datasourceIndex == NSNotFound)
    {
        //reserve ds index
        datasourceIndex = [[self.delegate entitiesDatasources]addDatasource:[[NSArray alloc]init] foriTunesCountry:country];
    }
    [self updateUI];
    
    _loadState = kITPLoadStateArtist;
    self.query.userCountry = self.delegate.entitiesDatasources.userCountry;
    self.query.priority = [self.delegate getLoadingPriority:self];
    
    [self.query loadEntitiesForArtistId:artistId inITunesCountry:country withType:type completionBlock:^(NSArray *array, NSError *err) {
        if(!err)
        {
            [[self.delegate entitiesDatasources] replaceDatasourceAtIndex:datasourceIndex entity:array foriTunesCountry:country];
        }
        self.loading = NO;
        [self updateUI];
        if(completion)
        {
            completion(array,err);
        }
    }];
}

-(void)showEntities:(NSArray*)array keepEntitiesNotInCountry:(BOOL)keepEntitiesNotInCountry highlightCells:(BOOL)highlightCells completionBlock:(ACKArrayResultBlock)completion
{
    self.highlightCells = highlightCells;
    self.loading = YES;
    
    _loadState = kITPLoadStateExternalEntities;
    self.query.userCountry = self.delegate.entitiesDatasources.userCountry;
    self.query.priority = [self.delegate getLoadingPriority:self];
    
    [self.query loadEntities:array inITunesStoreCountry:self.delegate.entitiesDatasources.userCountry keepEntitiesNotInCountry:keepEntitiesNotInCountry completionBlock:^(NSArray *array, NSError *err) {
        if(!err)
        {
            _itemsArray = [array copy];
        }
        self.loading = NO;
        [self updateUI];
        [self.tableView reloadData];
        if(completion)
        {
            completion(array,err);
        }
    }];
}

-(void)showAppsPriceDropsWithCompletionBlock:(ACKArrayResultBlock)completion
{
    self.loading = YES;
    
    _loadState = kITPLoadStateExternalEntities;
    self.query.userCountry = self.delegate.entitiesDatasources.userCountry;
    self.query.priority = [self.delegate getLoadingPriority:self];
    NSInteger limit = [[NSUserDefaults standardUserDefaults] integerForKey:DEFAULT_ACK_CHART_ITEMS_KEY];
    NSSet* languageCodes = [[NSSet alloc] initWithArray:@[@"en",[[NSLocale preferredLanguages]objectAtIndex:0]]];
    [self.query loadAppsPriceDropsInITunesStoreCountry:self.delegate.entitiesDatasources.userCountry
                                         withMediaType:self.delegate.entitiesDatasources.mediaEntityType
                                             withGenre:kITunesAppGenreTypeAll
                                withLanguageCodesISO2A:languageCodes
                                              freeOnly:NO limit:limit
                                       completionBlock:^(NSArray *array, NSError *err) {
        if(!err)
        {
            _itemsArray = [array copy];
        }
        self.loading = NO;
        [self updateUI];
        [self.tableView reloadData];
        if(completion)
        {
            completion(array,err);
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
    ACKITunesEntity* iTunesEntity = [self.ds objectAtIndex:indexPath.row];
    ITPPickerTableViewCell* cell = nil;
    //app
    if (iTunesEntity.iTunesEntityType == kITunesEntityTypeSoftware) {
        NSString *CellIdentifier = @"ITPAppPickerTableViewCell";
        cell = (ITPAppPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        }
    }
    //song
    else if (iTunesEntity.iTunesEntityType == kITunesEntityTypeMusic) {
        NSString *CellIdentifier = @"ITPAudioPickerTableViewCell";
        cell = (ITPAudioPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        }
    }
    //movie
    else if (iTunesEntity.iTunesEntityType == kITunesEntityTypeMovie) {
        NSString *CellIdentifier = @"ITPVideoPickerTableViewCell";
        cell = (ITPVideoPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        }
        ((ITPVideoPickerTableViewCell *)cell).rent = self.chartType == kITunesMovieChartTypeTopVideoRentals;
    }
    //book
    else if (iTunesEntity.iTunesEntityType == kITunesEntityTypeEBook) {
        NSString *CellIdentifier = @"ITPBookPickerTableViewCell";
        cell = (ITPBookPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        }
    }
    //music video
    else if (iTunesEntity.iTunesEntityType == kITunesEntityTypeMusicVideo) {
        NSString *CellIdentifier = @"ITPMusicVideoPickerTableViewCell";
        cell = (ITPMusicVideoPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        }
        ((ITPMusicVideoPickerTableViewCell*)cell).coverImageView.delegate = self;        
    }
    else
    {
        return cell;
    }
 
    [cell setLeftUtilityButtons:[self cellButtons:iTunesEntity] WithButtonWidth:62.0];
    cell.delegate = self;
    
    cell.iTunesEntity = iTunesEntity;
    cell.userCountry = [self.delegate entitiesDatasources].userCountry;
    cell.positionLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];    

    cell.detailButton.hidden = ![self.delegate respondsToSelector:@selector(openITunesEntityDetail:)];
    
    return cell;
}

#pragma mark- Table view delegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    ((ITPPickerTableViewCell*)cell).state = kITunesEntityStateNone;
    if(self.highlightCells)
    {
        if(!((ACKITunesEntity*)[self.ds objectAtIndex:indexPath.row]).existInUserCountry)
        {
            ((ITPPickerTableViewCell*)cell).state = kITunesEntityStateNotInTunesUserCountry;
        }
        
        NSArray* dsUser = [[self.delegate entitiesDatasources]getDatasourceForCountry:[self.delegate entitiesDatasources].userCountry];
        for (ACKITunesEntity* ent in dsUser) {
            if([ent isEqualToEntity:[self.ds objectAtIndex:indexPath.row]])
            {
                ((ITPPickerTableViewCell*)cell).state = kITunesEntityStateInUserCountryChart;
                break;
            }
        }
    }
}

-(void) closeAllCells
{
    [self closeAllCellsExceptAtIndexPath:nil];
}

-(void) closeAllCellsExceptAtIndexPath:(NSIndexPath*)indexPath
{
    for (ITPPickerTableViewCell* cell in [self.tableView visibleCells]) {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        if(!indexPath || ![cellIndexPath isEqual:indexPath])
        {
            [cell hideUtilityButtonsAnimated:YES];
        }
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self closeAllCells];
}

#pragma mark UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(text.length > 0)
    {
        self.loading = YES;
        _loadState = kITPLoadStateSearchTerms;
        tITunesMediaEntityType mediaEntityType = [self.delegate getSearchITunesMediaEntityType];
        NSInteger limit = [self.delegate entitiesDatasources].limit;
        self.query.userCountry = self.delegate.entitiesDatasources.userCountry;
        self.query.priority = [self.delegate getLoadingPriority:self];
        [self.query searchEntitiesForTerms:text inITunesStoreCountry:self.country withMediaType:mediaEntityType withAttribute:nil limit:limit completionBlock:^(NSArray *array, NSError *err) {
            if(!err)
            {
                _itemsArray = array;
            }
            else{
                _itemsArray = nil;
            }
            [self.tableView reloadData];
            self.loading = NO;
        }];
    }
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSString* text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(text.length == 0)
    {
        _itemsArray = nil;
        _loadState = kITPLoadStateRanking;
    }
    [self.tableView setUserInteractionEnabled:YES];
    [self.tableView reloadData];
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView setUserInteractionEnabled:NO];
    return YES;
}

#pragma mark ACKTrackMusicVideoPlayerDelegate

-(void)presentVideoPlayer:(MPMoviePlayerViewController*)moviePlayerView
{
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:moviePlayerView
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerView.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayerView.moviePlayer];
    ((ITPAppDelegate*)[UIApplication sharedApplication].delegate).allowOrientation = YES;
    self.moviePlayerController = moviePlayerView;
    [((UIViewController*)self.delegate).navigationController presentMoviePlayerViewControllerAnimated:self.moviePlayerController];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        ((ITPAppDelegate*)[UIApplication sharedApplication].delegate).allowOrientation = NO;

        [((UIViewController*)self.delegate).navigationController dismissMoviePlayerViewControllerAnimated];
        self.moviePlayerController = nil;
    }
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
    if(self.itemsArray)
    {
       return self.itemsArray;
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
    
    self.view.userInteractionEnabled = !loading;
    self.tableView.userInteractionEnabled = !loading;
    if(![self.delegate respondsToSelector:@selector(showLoadingHUD:sender:)])
    {
        return;
    }
    [self.delegate showLoadingHUD:loading sender:self];
}

-(void) updateUI
{
    [self.tableView reloadData];

    self.searchBar.hidden = ![self.delegate respondsToSelector:@selector(getSearchITunesMediaEntityType)];
    
    if(_loadState == kITPLoadStateArtist)
    {
        self.searchBar.hidden = YES;
        UIView *headerView = [[UIView alloc] initWithFrame:self.searchBar.bounds];
        UILabel *labelView = [[UILabel alloc] initWithFrame:self.searchBar.bounds];
        labelView.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:labelView];
        if(self.ds.count > 0)
        {
            ACKITunesEntity* ent = [self.ds objectAtIndex:0];
            labelView.text = ent.artistName;
            self.tableView.tableHeaderView = headerView;
        }
    }
    if(_loadState == kITPLoadStateExternalEntities)
    {
        self.tableView.tableHeaderView = nil;
        [self.view setNeedsUpdateConstraints];
    }
}

#pragma mark - cell menu
- (NSArray *)cellButtons:(ACKITunesEntity*) iTunesEntity
{
    NSMutableArray *cellUtilityButtons = [NSMutableArray new];

    if([iTunesEntity isKindOfClass:[ACKBook class]])
    {
        [cellUtilityButtons sw_addUtilityButtonWithColor: [[ITPGraphic sharedInstance] commonColor] title:@"iBooks"];
    }
    else if([iTunesEntity isKindOfClass:[ACKApp class]])
    {
        [cellUtilityButtons sw_addUtilityButtonWithColor:[[ITPGraphic sharedInstance] commonColor] normalIcon:[UIImage imageNamed:@"appstore"] selectedIcon:[UIImage imageNamed:@"appstore"]];
    }
    else
    {
        [cellUtilityButtons sw_addUtilityButtonWithColor: [[ITPGraphic sharedInstance] commonColor] title:@"iTunes"];
    }
    [cellUtilityButtons sw_addUtilityButtonWithColor:FlatGreenDark normalIcon:[UIImage imageNamed:@"share"] selectedIcon:[UIImage imageNamed:@"share"]];
    [cellUtilityButtons sw_addUtilityButtonWithColor:FlatYellowDark normalIcon:[UIImage imageNamed:@"world"] selectedIcon:[UIImage imageNamed:@"world"]];
    
    if(![iTunesEntity isKindOfClass:[ACKBook class]])
    {
        if((![iTunesEntity isKindOfClass:[ACKApp class]] && YOUTUBE_API_KEY.length > 0)||
           ([iTunesEntity isKindOfClass:[ACKApp class]] && [self.delegate respondsToSelector:@selector(openITunesEntityDetail:)] &&
            ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1 || !iTunesEntity.existInUserCountry) )))
        {
            [cellUtilityButtons sw_addUtilityButtonWithColor: FlatOrangeDark normalIcon:[UIImage imageNamed:@"search"] selectedIcon:[UIImage imageNamed:@"search"]];
        }
    }
    
    return cellUtilityButtons;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            ACKITunesQuery* query = [[ACKITunesQuery alloc]init];
            query.cachePolicyChart = NSURLRequestUseProtocolCachePolicy;
            query.cachePolicyLoadEntity = NSURLRequestUseProtocolCachePolicy;
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            ACKITunesEntity* iTunesEntity = [self.ds objectAtIndex:cellIndexPath.row];
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1 || !iTunesEntity.existInUserCountry) {
                [query openEntity:iTunesEntity inITunesStoreCountry:[self.delegate entitiesDatasources].userCountry isGift:NO completionBlock:^(BOOL succeeded, NSError *err) {
                    if(!succeeded || err)
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_title_item_not_in_user_country",nil) message:NSLocalizedString(@"error_message_item_not_in_user_country",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"button_cancel",nil), nil];
                        [alert show];
                    }
                }];
            }
            else
            {
                self.loading = YES;
                [[ITPGraphic sharedInstance] changeNavBar];
                [query presentStoreProduct:iTunesEntity inITunesStoreCountry:[self.delegate entitiesDatasources].userCountry inUIViewController:(UIViewController<SKStoreProductViewControllerDelegate>*)self.delegate completionBlock:^(BOOL succeeded, NSError *err) {
                    self.loading = NO;
                }];
            }
            break;
        }
        case 1:
        {
            [[ITPGraphic sharedInstance] changeNavBar];
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            ACKITunesEntity* iTunesEntity = [self.ds objectAtIndex:cellIndexPath.row];
            [ACKShareITunesEntity presentShareInUIViewController:(ITPViewController*)self.delegate forITunesEntity:iTunesEntity inITunesStoreCountry:[self.delegate entitiesDatasources].userCountry withString:iTunesEntity.description completion:^{
                [[ITPGraphic sharedInstance] initCommonUXAppearance];
            }];
            break;
        }
        case 2:
        {
            if(![self.delegate respondsToSelector:@selector(selectEntity:)])
            {
                return;
            }
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            ACKITunesEntity* iTunesEntity = [self.ds objectAtIndex:cellIndexPath.row];
            [self.delegate selectEntity:iTunesEntity];
            break;
        }
        case 3:
        {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            ACKITunesEntity* iTunesEntity = [self.ds objectAtIndex:cellIndexPath.row];
            
            if([iTunesEntity isKindOfClass:[ACKApp class]])
            {
                if(![self.delegate respondsToSelector:@selector(openITunesEntityDetail:)])
                {
                    return;
                }
                if(iTunesEntity.existInUserCountry && ![self.country isEqual:[self.delegate entitiesDatasources].userCountry])
                {
                    self.tableView.userInteractionEnabled = NO;
                    self.query.priority = [self.delegate getLoadingPriority:self];
                    [self.query loadEntity:iTunesEntity inITunesStoreCountry:[self.delegate entitiesDatasources].userCountry completionBlock:^(ACKITunesEntity *userCountryEntity, NSError *err) {
                        if(!err)
                        {
                            userCountryEntity.userData = self;
                            [self.delegate openITunesEntityDetail:userCountryEntity];
                        }
                        else
                        {
                            iTunesEntity.userData = self;
                            [self.delegate openITunesEntityDetail:iTunesEntity];
                        }
                        self.tableView.userInteractionEnabled = YES;
                    }];
                }
                else
                {
                    iTunesEntity.userData = self;
                    [self.delegate openITunesEntityDetail:iTunesEntity];
                }
                return;
            }
            
            [[ACKYouTube sharedInstance]performVideoSearchForITunesEntity:iTunesEntity limit:MAX_YOUTUBE_SEARCH_LIMIT country:iTunesEntity.country APIKey:YOUTUBE_API_KEY completion:^(NSError *error, NSArray *result) {
                    if(!result)
                    {
                        result = [[NSArray alloc]init];
                    }
                    ITPYouTubeViewController* youTubeContoller = [[ITPYouTubeViewController alloc]initWithNibName:nil bundle:nil];
                    youTubeContoller.videosArray = result;
                    [((UIViewController*)self.delegate).navigationController pushViewController:youTubeContoller animated:YES];
            }];

        }
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    if(state != kCellStateCenter)
    {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        [self closeAllCellsExceptAtIndexPath:cellIndexPath];
    }
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = NSLocalizedString(@"error_nodata", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [[ITPGraphic sharedInstance] commonColor]};
                                 
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"logo"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.loading;
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return CGPointMake(0, self.tableView.tableHeaderView.frame.size.height);
}


@end
