//
//  ITPPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPAppPickerTableViewCell.h"

@implementation ITPAppPickerTableViewCell

@synthesize iTunesEntity=_iTunesEntity;

-(void) initCell
{
    [super initCell];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;

    self.starImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.starImageView.clipsToBounds = YES;
    self.starImageView.frame = CGRectMake(self.starImageView.frame.origin.x,self.starImageView.frame.origin.y,self.starImageView.frame.size.width,9.5f);
    
    self.starAllVersionsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.starAllVersionsImageView.clipsToBounds = YES;
    self.starAllVersionsImageView.frame = CGRectMake(self.starAllVersionsImageView.frame.origin.x,self.starAllVersionsImageView.frame.origin.y,self.starAllVersionsImageView.frame.size.width,9.5f);

    self.appNameLabel.adjustsFontSizeToFitWidth = YES;
    self.ratingsAllVersionsLabel.adjustsFontSizeToFitWidth = YES;    
    self.noRatingsLabel.text = NSLocalizedString(@"itppicker.tablecell.app.noratings",nil);
    self.noRatingsAllVersionsLabel.text = NSLocalizedString(@"itppicker.tablecell.app.noratings.allversions",nil);
}

#pragma mark - Property methods


- (void)setITunesEntity:(ACKITunesEntity *)ent
{
    _iTunesEntity = ent;
    ACKApp* appObject = (ACKApp*)ent;
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
    
    self.ratingsAllVersionsLabel.text = [NSString stringWithFormat:@"(%@ %@)", [formatter stringFromNumber:userRatingCountAllVersions],NSLocalizedString(@"itppicker.tablecell.app.label.allVersions",nil)];
    self.ratingsAllVersionsLabel.hidden = [userRatingCountAllVersions doubleValue]== 0;
    self.noRatingsAllVersionsLabel.hidden = [userRatingCountAllVersions doubleValue]> 0;
    self.starAllVersionsImageView.hidden = [userRatingCountAllVersions doubleValue]== 0;
    
    self.priceLabel.text = appObject.formattedPrice;
    [self.detailButton setTitle:NSLocalizedString(@"itppicker.tablecell.app.button.detail",nil) forState:UIControlStateNormal];
    
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
    self.iconView.app = appObject;
}

-(void) prepareForReuse
{
    [super prepareForReuse];
    self.starImageView.frame = CGRectMake(self.starImageView.frame.origin.x,self.starImageView.frame.origin.y,self.starImageView.frame.size.width,9.5f);
    self.starAllVersionsImageView.frame = CGRectMake(self.starAllVersionsImageView.frame.origin.x,self.starAllVersionsImageView.frame.origin.y,self.starAllVersionsImageView.frame.size.width,9.5f);
}


@end
