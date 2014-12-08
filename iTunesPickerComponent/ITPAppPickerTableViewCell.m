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
    
    self.ratingsLabel.text = [NSString stringWithFormat:@"%.1lf/5.0 (%@)",[appObject.averageUserRatingForCurrentVersion doubleValue] , [formatter stringFromNumber:appObject.userRatingCountForCurrentVersion]];
    self.ratingsLabel.hidden = appObject.userRatingCountForCurrentVersion == 0;
    self.noRatingsLabel.hidden = [appObject.userRatingCountForCurrentVersion doubleValue] > 0;
    
    NSNumber* userRatingCountAllVersions = appObject.userRatingCount;
    if(appObject.userRatingCount < appObject.userRatingCountForCurrentVersion)
    {
        userRatingCountAllVersions = appObject.userRatingCountForCurrentVersion;
    }
    
    self.ratingsAllVersionsLabel.text = [NSString stringWithFormat:@"%.1lf/5.0 (%@ %@)",[appObject.averageUserRating doubleValue], [formatter stringFromNumber:userRatingCountAllVersions],NSLocalizedString(@"itppicker.tablecell.app.label.allVersions",nil)];
    self.ratingsAllVersionsLabel.hidden = [userRatingCountAllVersions doubleValue]== 0;
    self.noRatingsAllVersionsLabel.hidden = [userRatingCountAllVersions doubleValue]> 0;
    
    if(appObject.priceDrop)
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init]; //create a formatter inside a cell is not good
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencyCode:appObject.currency];
        numberFormatter.locale = [NSLocale currentLocale]; //warning: returns en_US in iOS 8.1 simulator only, works well on 8.1 devices.
        NSString* toPriceStr = [numberFormatter stringFromNumber:appObject.priceDrop.toPrice];
        if([appObject.priceDrop.toPrice doubleValue]==0)
        {
            toPriceStr = appObject.formattedPrice;
        }
        NSString* priceLabel = [NSString stringWithFormat:NSLocalizedString(@"itppicker.tablecell.app.pricedrop",nil),[numberFormatter stringFromNumber:appObject.priceDrop.fromPrice],toPriceStr];
        self.priceLabel.text = priceLabel;
    }
    else
    {
        self.priceLabel.text = appObject.formattedPrice;
    }
    if(!appObject.existInUserCountry)
    {
        self.priceLabel.text = @"  ";
    }
    
    [self.detailButton setTitle:NSLocalizedString(@"itppicker.tablecell.app.button.detail",nil) forState:UIControlStateNormal];
    
    self.iconView.showActivityIndicator = YES;
    self.iconView.app = appObject;
    self.iconViewButton.userInteractionEnabled = appObject.iTunesMediaEntityType != kITunesMediaEntityTypeSoftwareMac;
}



@end
