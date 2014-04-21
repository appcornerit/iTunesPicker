//
//  ITPPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewCell.h"

@implementation ITPPickerTableViewCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self initCell];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initCell];
    }
    return self;
}

-(void) initCell
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
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
    self.noRatingsLabel.text = NSLocalizedString(@"itppicker.table.noratings",nil);
    self.noRatingsLabel.hidden = YES;
    
    self.noRatingsAllVersionsLabel.font = [UIFont systemFontOfSize:9.0f];
    self.noRatingsAllVersionsLabel.textColor = [UIColor colorWithWhite:99.0f/255.0f alpha:1.0f];
    self.noRatingsAllVersionsLabel.backgroundColor = [UIColor clearColor];
    self.noRatingsAllVersionsLabel.text = NSLocalizedString(@"itppicker.table.noratings.allversions",nil);
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
}

#pragma mark Action

- (IBAction)openiTunesStore:(id)sender
{
    if(sender == self.detailButton)
    {
        UITableView *tableView = (UITableView *)self.superview;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            tableView = (UITableView *)tableView.superview;
        }
        NSIndexPath *pathOfTheCell = [tableView indexPathForCell:self];
        if ([tableView.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        {
            [tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:pathOfTheCell];
        }
    }
    else
    {
        ACKITunesQuery* query = [[ACKITunesQuery alloc]init];
        query.cachePolicyChart = NSURLRequestUseProtocolCachePolicy;
        query.cachePolicyLoadEntity = NSURLRequestUseProtocolCachePolicy;
        
        [query openEntity:self.appObject inITunesStoreCountry:self.userCountry completionBlock:^(BOOL succeeded, NSError *err) {
            if(!succeeded || err)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error open iTunes Store",nil) message:NSLocalizedString(@"The selected item not exits in your country",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Cancel",nil), nil];
                [alert show];
            }
        }];
    }
}

#pragma mark - Property methods

- (void)setAppObject:(ACKApp *)appObject
{
    _appObject = appObject;
    self.appNameLabel.text = appObject.trackName;
    self.genreLabel.text = appObject.primaryGenreName;
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.ratingsLabel.text = [NSString stringWithFormat:@"(%@)", [formatter stringFromNumber:appObject.userRatingCountForCurrentVersion]];
    self.ratingsLabel.hidden = appObject.userRatingCountForCurrentVersion == 0;
    self.noRatingsLabel.hidden = [appObject.userRatingCountForCurrentVersion doubleValue] > 0;
    self.starImageView.hidden = [appObject.userRatingCountForCurrentVersion doubleValue] == 0;
    
    NSNumber* userRatingCountAllVersions = appObject.userRatingCount;
    if(appObject.userRatingCount < appObject.userRatingCountForCurrentVersion)
    {
        userRatingCountAllVersions = appObject.userRatingCountForCurrentVersion;
    }
    
    self.ratingsAllVersionsLabel.text = [NSString stringWithFormat:@"(%@ %@)", [formatter stringFromNumber:userRatingCountAllVersions],NSLocalizedString(@"itppicker.table.label.allVersions",nil)];
    self.ratingsAllVersionsLabel.hidden = [userRatingCountAllVersions doubleValue]== 0;
    self.noRatingsAllVersionsLabel.hidden = [userRatingCountAllVersions doubleValue]> 0;
    self.starAllVersionsImageView.hidden = [userRatingCountAllVersions doubleValue]== 0;
    
    self.priceLabel.text = appObject.formattedPrice;
    [self.detailButton setTitle:NSLocalizedString(@"itppicker.table.button.detail",nil) forState:UIControlStateNormal];
    
    UIImage *starsImage = [UIImage imageNamed:@"stars.png"];
    UIGraphicsBeginImageContextWithOptions(self.starImageView.frame.size, NO, 0);
    CGPoint starPoint = (CGPoint) {
        .y = (self.starImageView.frame.size.height * (2 * [appObject.averageUserRatingForCurrentVersion doubleValue] + 1)) - starsImage.size.height
    };
    [starsImage drawAtPoint:starPoint];
    self.starImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *starsAllVersionsImage = [UIImage imageNamed:@"stars.png"];
    UIGraphicsBeginImageContextWithOptions(self.starAllVersionsImageView.frame.size, NO, 0);
    CGPoint starAllVersionsPoint = (CGPoint) {
        .y = (self.starAllVersionsImageView.frame.size.height * (2 * [appObject.averageUserRating doubleValue] + 1)) - starsAllVersionsImage.size.height
    };
    [starsAllVersionsImage drawAtPoint:starAllVersionsPoint];
    self.starAllVersionsImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.iconView.showActivityIndicator = YES;
    self.iconView.app = self.appObject;
}

-(void) prepareForReuse
{
    [super prepareForReuse];
    self.starImageView.frame = CGRectMake(self.starImageView.frame.origin.x,self.starImageView.frame.origin.y,self.starImageView.frame.size.width,9.5f);
    self.starAllVersionsImageView.frame = CGRectMake(self.starAllVersionsImageView.frame.origin.x,self.starAllVersionsImageView.frame.origin.y,self.starAllVersionsImageView.frame.size.width,9.5f);
}

@end
