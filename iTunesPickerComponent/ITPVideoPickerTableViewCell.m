//
//  ITPVideoPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 27/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPVideoPickerTableViewCell.h"
@implementation ITPVideoPickerTableViewCell

@synthesize iTunesEntity=_iTunesEntity;

#pragma mark - Property methods
- (void)setITunesEntity:(ACKITunesEntity *)ent
{
    _iTunesEntity = ent;
    ACKTrackMovie* movieObject = (ACKTrackMovie*)ent;
    self.trackNameLabel.text = movieObject.trackName;
    if(movieObject.collectionName)
    {
        self.artistLabel.text = [NSString stringWithFormat:@"%@ - %@",movieObject.artistName,movieObject.collectionName];
    }
    else
    {
        self.artistLabel.text = movieObject.artistName;        
    }
    self.genreLabel.text = movieObject.primaryGenreName;
    
    double time = [movieObject.trackTimeMillis doubleValue];
    NSString* hours = [NSString stringWithFormat:@"%02i",(int)( time / (1000*60*60)) ];
    NSString* minutes = [NSString stringWithFormat:@"%02i",(int)(fmodf(time , (1000*60*60)) / (1000*60)) ];
    self.trackTimeLabel.text = [NSString stringWithFormat:@"%@:%@",hours,minutes];
    self.trackExplicitness.text = [movieObject.trackExplicitness isEqualToString:kITunesMusicNotExplicit]?@"":NSLocalizedString(@"trackExplicit",nil);
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setDecimalSeparator:@"."];    
    NSNumber * priceSDNumber = nil;
    NSNumber * priceHDNumber = nil;
    if(self.rent)
    {
        priceSDNumber = [f numberFromString:movieObject.trackRentalPrice];
        priceHDNumber = [f numberFromString:movieObject.trackHdRentalPrice];
    }
    else
    {
        priceSDNumber = [f numberFromString:movieObject.trackPrice];
        priceHDNumber = [f numberFromString:movieObject.trackHdPrice];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:movieObject.currency];
    [formatter setLocale:[NSLocale currentLocale]];
    self.priceLabel.text = [NSString stringWithFormat:@"SD %@ / HD %@", [formatter stringFromNumber:priceSDNumber],[formatter stringFromNumber:priceHDNumber]];
    
    //movie is DRM protected video file, I can't show the preview in app.
    self.genreLabel.text = movieObject.primaryGenreName;
    self.coverImageView.showActivityIndicator = YES;
    self.coverImageView.entity = movieObject;
}

@end
