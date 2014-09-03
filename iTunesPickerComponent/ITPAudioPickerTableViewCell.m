//
//  ITPAudioPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 27/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPAudioPickerTableViewCell.h"
#import "ITPGraphic.h"
@implementation ITPAudioPickerTableViewCell

@synthesize iTunesEntity=_iTunesEntity;

#pragma mark - Property methods
- (void)setITunesEntity:(ACKITunesEntity *)ent
{
    _iTunesEntity = ent;
    if([ent isKindOfClass:[ACKTrackSong class]])
    {
        ACKTrackSong* songObject = (ACKTrackSong*)ent;
        self.trackNameLabel.text = songObject.trackName;
        self.artistLabel.text = [NSString stringWithFormat:@"%@ - %@",songObject.artistName,songObject.collectionName];
        self.genreLabel.text = songObject.primaryGenreName;
        
        double time = [songObject.trackTimeMillis doubleValue];
        NSString* minutes = [NSString stringWithFormat:@"%02i",(int)(fmodf(time , (1000*60*60)) / (1000*60)) ];
        NSString* seconds = [NSString stringWithFormat:@"%02i",(int)(fmodf(fmodf(time , (1000*60*60)) , (1000*60)) / 1000)];
        self.trackTimeLabel.text = [NSString stringWithFormat:@"%@:%@",minutes,seconds];
        self.trackExplicitness.text = [songObject.trackExplicitness isEqualToString:kITunesMusicNotExplicit]?@"":NSLocalizedString(@"trackExplicit",nil);
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setDecimalSeparator:@"."];
        NSNumber * priceNumber = [f numberFromString:songObject.trackPrice];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyCode:songObject.currency];
        [formatter setLocale:[NSLocale currentLocale]];
        self.priceLabel.text = [formatter stringFromNumber:priceNumber];
        
        self.genreLabel.text = songObject.primaryGenreName;
        self.musicPlayerView.showActivityIndicator = YES;
        self.musicPlayerView.song = songObject;
        self.musicPlayerView.hidden = NO;
        self.musicPlayerView.layer.masksToBounds = YES;
        self.musicPlayerView.layer.cornerRadius = self.musicPlayerView.frame.size.width/2.0;
        self.musicPlayerView.playerIndicatorColor = [[ITPGraphic sharedInstance] commonColor];
        self.musicPlayerView.playerBarIndicatorColor  = [[ITPGraphic sharedInstance] commonContrastColor];
        self.coverImageView.hidden = YES;
    }
    else if([ent isKindOfClass:[ACKAlbum class]])
    {
        ACKAlbum* albumObject = (ACKAlbum*)ent;
        self.trackNameLabel.text = albumObject.collectionName;
        self.artistLabel.text = albumObject.artistName;
        self.genreLabel.text = albumObject.primaryGenreName;
        
        self.trackTimeLabel.text = [NSString stringWithFormat:@"%d", [albumObject.trackCount integerValue]];
        self.trackExplicitness.text = [albumObject.collectionExplicitness isEqualToString:kITunesMusicNotExplicit]?@"":NSLocalizedString(@"trackExplicit",nil);
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setDecimalSeparator:@"."];
        if(!albumObject.collectionPrice)  //nil when available for preorder only, check release date
        {
           self.priceLabel.text = NSLocalizedString(@"preorder",nil);
        }
        else
        {
            NSNumber * priceNumber = [f numberFromString:albumObject.collectionPrice];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [formatter setCurrencyCode:albumObject.currency];
            [formatter setLocale:[NSLocale currentLocale]];
            self.priceLabel.text = [formatter stringFromNumber:priceNumber];
        }
        
        self.genreLabel.text = albumObject.primaryGenreName;
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.coverImageView.showActivityIndicator = YES;
        self.coverImageView.entity = albumObject;
        self.coverImageView.hidden = NO;
        self.musicPlayerView.hidden = YES;
    }
    
    if(!ent.existInUserCountry)
    {
        self.priceLabel.text = @"  ";
    }
}

-(void)prepareForReuse
{
    self.musicPlayerView.playerIndicatorColor = [[ITPGraphic sharedInstance] commonColor];
    self.musicPlayerView.playerBarIndicatorColor  = [[ITPGraphic sharedInstance] commonContrastColor];
}

@end
