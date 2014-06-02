//
//  ITPMusicVideoPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 01/06/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPMusicVideoPickerTableViewCell.h"

@implementation ITPMusicVideoPickerTableViewCell

@synthesize iTunesEntity=_iTunesEntity;

#pragma mark - Property methods
- (void)setITunesEntity:(ACKITunesEntity *)ent
{
    _iTunesEntity = ent;
    ACKTrackMusicVideo* musicVideoObject = (ACKTrackMusicVideo*)ent;
    self.trackNameLabel.text = musicVideoObject.trackName;
    self.artistLabel.text = musicVideoObject.artistName;
    self.genreLabel.text = musicVideoObject.primaryGenreName;
    
    double time = [musicVideoObject.trackTimeMillis doubleValue];
    NSString* minutes = [NSString stringWithFormat:@"%02i",(int)(fmodf(time , (1000*60*60)) / (1000*60)) ];
    NSString* seconds = [NSString stringWithFormat:@"%02i",(int)(fmodf( fmodf(time,(1000*60*60)) ,(1000*60)) / 1000)];
    self.trackTimeLabel.text = [NSString stringWithFormat:@"%@:%@",minutes,seconds];
    self.trackExplicitness.text = [musicVideoObject.trackExplicitness isEqualToString:kITunesMusicNotExplicit]?@"":NSLocalizedString(@"trackExplicit",nil);
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setDecimalSeparator:@"."];
    NSNumber * priceNumber = [f numberFromString:musicVideoObject.trackPrice];
    if([priceNumber floatValue]<=0)
    {
        priceNumber = [f numberFromString:musicVideoObject.collectionPrice];
    }
    if([priceNumber floatValue]>0)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyCode:musicVideoObject.currency];
        [formatter setLocale:[NSLocale currentLocale]];
        self.priceLabel.text = [formatter stringFromNumber:priceNumber];
    }
    else
    {
        self.priceLabel.text = @"";
    }
    self.coverImageView.showActivityIndicator = YES;
    self.coverImageView.musicVideo = musicVideoObject;
}

@end
