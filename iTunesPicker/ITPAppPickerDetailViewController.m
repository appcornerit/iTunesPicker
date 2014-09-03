//
//  ITPPickerDetailViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 24/03/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPAppPickerDetailViewController.h"
#import "ITPPickerTableViewControllerDelegate.h"
#import "ITPPickerTableViewController.h"
#import "ITPGraphic.h"
#import "SVProgressHUD.h"

@interface ITPAppPickerDetailViewController ()<SwipeViewDataSource, UITableViewDataSource, UITableViewDelegate, ITPPickerTableViewControllerDelegate>
{
    NSDateFormatter *dateFormatter;
}
@property (nonatomic,strong) ACKEntitiesContainer* entitiesDatasources;
@end

@implementation ITPAppPickerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.appNameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.appNameLabel.backgroundColor = [UIColor clearColor];
    self.appNameLabel.textColor = [UIColor colorWithWhite:78.0f/255.0f alpha:1.0f];
    self.appNameLabel.numberOfLines = 1;
    self.appNameLabel.minimumScaleFactor = 12.0;
    self.appNameLabel.adjustsFontSizeToFitWidth = YES;
    
    self.genreLabel.font = [UIFont systemFontOfSize:10.0f];
    self.genreLabel.backgroundColor = [UIColor clearColor];
    self.genreLabel.textColor = [UIColor colorWithWhite:99.0f/255.0f alpha:1.0f];
    
    self.starImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.starImageView.clipsToBounds = YES;
    self.starImageView.frame = CGRectMake(self.starImageView.frame.origin.x,self.starImageView.frame.origin.y,self.starImageView.frame.size.width,9.5f);
    
    self.starAllVersionsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.starAllVersionsImageView.clipsToBounds = YES;
    self.starAllVersionsImageView.frame = CGRectMake(self.starAllVersionsImageView.frame.origin.x,self.starAllVersionsImageView.frame.origin.y,self.starAllVersionsImageView.frame.size.width,9.5f);
    
    self.noRatingsLabel.font = [UIFont systemFontOfSize:9.0f];
    self.noRatingsLabel.textColor = [UIColor colorWithWhite:99.0f/255.0f alpha:1.0f];
    self.noRatingsLabel.backgroundColor = [UIColor clearColor];
    self.noRatingsLabel.text = NSLocalizedString(@"itppicker.tablecell.app.noratings",nil);
    self.noRatingsLabel.hidden = YES;
    
    self.noRatingsAllVersionsLabel.font = [UIFont systemFontOfSize:9.0f];
    self.noRatingsAllVersionsLabel.textColor = [UIColor colorWithWhite:99.0f/255.0f alpha:1.0f];
    self.noRatingsAllVersionsLabel.backgroundColor = [UIColor clearColor];
    self.noRatingsAllVersionsLabel.text = NSLocalizedString(@"itppicker.tablecell.app.noratings.allversions",nil);
    self.noRatingsAllVersionsLabel.hidden = YES;
    
    self.ratingsLabel.font = [UIFont systemFontOfSize:10.0f];
    self.ratingsLabel.textColor = [UIColor colorWithWhite:90.0f/255.0f alpha:1.0f];
    self.ratingsLabel.backgroundColor = [UIColor clearColor];
    
    self.ratingsAllVersionsLabel.font = [UIFont systemFontOfSize:10.0f];
    self.ratingsAllVersionsLabel.textColor = [UIColor colorWithWhite:90.0f/255.0f alpha:1.0f];
    self.ratingsAllVersionsLabel.backgroundColor = [UIColor clearColor];
    self.ratingsAllVersionsLabel.minimumScaleFactor = 9.0;
    self.ratingsAllVersionsLabel.adjustsFontSizeToFitWidth = YES;
    
    self.priceLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.priceLabel.backgroundColor = [UIColor clearColor];
    self.priceLabel.textColor = [UIColor colorWithWhite:78.0f/255.0f alpha:1.0f];
    
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    [self.purchaseButton setTitle:NSLocalizedString(@"itppicker.detail.app.button.purchase",nil) forState:UIControlStateNormal];
    self.purchaseButton.plusIconVisible = [self.appObject isUniversal];
    self.purchaseButton.hidden = self.appObject.iTunesMediaEntityType == kITunesMediaEntityTypeSoftwareMac;

    UIImage *starsImage = [UIImage imageNamed:@"stars.png"];
    UIGraphicsBeginImageContextWithOptions(self.starImageView.frame.size, NO, 0);
    CGPoint starPoint = (CGPoint) {
        .y = (self.starImageView.frame.size.height * (2 * [self.appObject.averageUserRatingForCurrentVersion doubleValue] + 1)) - starsImage.size.height
    };
    [starsImage drawAtPoint:starPoint];
    self.starImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *starsAllVersionsImage = [UIImage imageNamed:@"stars.png"];
    UIGraphicsBeginImageContextWithOptions(self.starAllVersionsImageView.frame.size, NO, 0);
    CGPoint starAllVersionsPoint = (CGPoint) {
        .y = (self.starAllVersionsImageView.frame.size.height * (2 * [self.appObject.averageUserRating doubleValue] + 1)) - starsAllVersionsImage.size.height
    };
    [starsAllVersionsImage drawAtPoint:starAllVersionsPoint];
    self.starAllVersionsImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.appNameLabel.text = self.appObject.trackName;
    self.genreLabel.text = self.appObject.primaryGenreName;
    
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.ratingsLabel.text = [NSString stringWithFormat:@"(%@)", [decimalFormatter stringFromNumber:self.appObject.userRatingCountForCurrentVersion]];
    self.ratingsLabel.hidden = self.appObject.userRatingCountForCurrentVersion == 0;
    self.noRatingsLabel.hidden = [self.appObject.userRatingCountForCurrentVersion doubleValue] > 0;
    self.starImageView.hidden = [self.appObject.userRatingCountForCurrentVersion doubleValue] == 0;
    
    NSNumber* userRatingCountAllVersions = self.appObject.userRatingCount;
    if(self.appObject.userRatingCount < self.appObject.userRatingCountForCurrentVersion)
    {
        userRatingCountAllVersions = self.appObject.userRatingCountForCurrentVersion;
    }
    
    self.ratingsAllVersionsLabel.text = [NSString stringWithFormat:@"(%@ %@)", [decimalFormatter stringFromNumber:userRatingCountAllVersions],NSLocalizedString(@"itppicker.tablecell.app.label.allVersions",nil)];
    self.ratingsAllVersionsLabel.hidden = [userRatingCountAllVersions doubleValue]== 0;
    self.noRatingsAllVersionsLabel.hidden = [userRatingCountAllVersions doubleValue]> 0;
    self.starAllVersionsImageView.hidden = [userRatingCountAllVersions doubleValue]== 0;
    
    self.priceLabel.text = self.appObject.formattedPrice;
    
    self.iconView.showActivityIndicator = YES;
    self.iconView.app = self.appObject;
    
    self.previewScrollView.item = self.appObject;
 
    self.entitiesDatasources = [[ACKEntitiesContainer alloc]initWithUserCountry:self.delegate.entitiesDatasources.userCountry entityType:kITunesEntityTypeSoftware mediaEntityType:kITunesMediaEntityTypeDefaultForEntity limit:kITunesMaxLimitLoadEntities];
}

- (void)dealloc
{
    self.delegate = nil;
}

#pragma mark Action

- (IBAction)openiTunesStore:(id)sender
{
    ACKITunesQuery* query = [[ACKITunesQuery alloc]init];
    query.cachePolicyChart = NSURLRequestUseProtocolCachePolicy;
    query.cachePolicyLoadEntity = NSURLRequestUseProtocolCachePolicy;
    
    [query openEntity:self.appObject inITunesStoreCountry:self.delegate.entitiesDatasources.userCountry isGift:NO completionBlock:^(BOOL succeeded, NSError *err) {
        if(!succeeded || err)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_title_item_not_in_user_country",nil) message:NSLocalizedString(@"error_message_item_not_in_user_country",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"button_cancel",nil), nil];
            [alert show]; 
        }
    }];
}

#pragma mark SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return 2;
}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    self.pageControl.currentPage = index;    
    if(index == 0)
    {
        if(!self.descriptionTextView)
        {
            self.descriptionTextView = [[UITextView alloc]initWithFrame:swipeView.bounds];
        }
        self.descriptionTextView.text = self.appObject.description;
        self.descriptionTextView.editable = NO;
        return self.descriptionTextView;
    }
    else
    {
        if(!self.detailTableView)
        {
            self.detailTableView = [[UITableView alloc]initWithFrame:swipeView.bounds];
            self.detailTableView.dataSource = self;
            self.detailTableView.delegate = self;
            self.detailTableView.separatorColor = [UIColor clearColor];
            self.detailTableView.allowsSelection = self.allowsSelection;
        }
        return self.detailTableView;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"DetailItemCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.detailTextLabel.textColor = [UIColor blackColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = self.appObject.artistName;
            cell.detailTextLabel.text = NSLocalizedString(@"itppicker.detail.app.label.developer",nil);
            if(self.allowsSelection)
            {
                cell.detailTextLabel.textColor = [UIColor blueColor];
            }
            break;
        case 1:
            cell.textLabel.text = self.appObject.sellerName;
            cell.detailTextLabel.text = NSLocalizedString(@"itppicker.detail.app.label.seller",nil);
            break;
        case 2:
            cell.textLabel.text = [dateFormatter stringFromDate:self.appObject.releaseDate];
            cell.detailTextLabel.text = NSLocalizedString(@"itppicker.detail.app.label.update",nil);
            break;
        case 3:
            cell.textLabel.text = self.appObject.version;
            cell.detailTextLabel.text = NSLocalizedString(@"itppicker.detail.app.label.version",nil);
            break;
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"%d MB",(int)round([self.appObject.fileSizeBytes doubleValue]/(1024*1024))];
            cell.detailTextLabel.text = NSLocalizedString(@"itppicker.detail.app.label.size",nil);
            break;
        case 5:
            cell.textLabel.text = self.appObject.contentAdvisoryRating;
            cell.detailTextLabel.text = NSLocalizedString(@"itppicker.detail.app.label.rating",nil);
            break;
        case 6:
            cell.textLabel.text = [self.appObject.languageCodesISO2A componentsJoinedByString:@","];
            cell.detailTextLabel.text = NSLocalizedString(@"itppicker.detail.app.label.languages",nil);
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        if(![self.pickerCountry isEqualToString:self.delegate.entitiesDatasources.userCountry])
        {
            [self.entitiesDatasources addDatasource:[self.delegate.entitiesDatasources getDatasourceForCountry:self.delegate.entitiesDatasources.userCountry] foriTunesCountry:self.delegate.entitiesDatasources.userCountry];
        }
        ITPPickerTableViewController* pickerTableView = [[ITPPickerTableViewController alloc]initWithNibName:nil bundle:nil];
        pickerTableView.delegate = self;
        [pickerTableView loadEntitiesForArtistId:self.appObject.artistId inITunesCountry:self.pickerCountry withType:self.appObject.iTunesEntityType completionBlock:^(NSArray *array, NSError *err) {
                [self.navigationController pushViewController:pickerTableView animated:YES];
        }];
        
    }
}

#pragma mark - ITPViewControllerDelegate

-(NSOperationQueuePriority)getLoadingPriority:(id)sender
{
   return [self.delegate getLoadingPriority:sender];
}

-(void)showLoadingHUD:(BOOL)loading
{
    if(loading)
    {
        [SVProgressHUD setForegroundColor:[[ITPGraphic sharedInstance]commonContrastColor]];
        [SVProgressHUD setBackgroundColor:[[ITPGraphic sharedInstance]commonColor]];
        [SVProgressHUD setRingThickness:2.0];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(void)selectEntity:(ACKITunesEntity*)entity
{
    [self.delegate selectEntity:entity];
}

//-(void)openITunesEntityDetail:(ACKITunesEntity*)entity
//{
//    [self.delegate openITunesEntityDetail:entity];
//}

@end
