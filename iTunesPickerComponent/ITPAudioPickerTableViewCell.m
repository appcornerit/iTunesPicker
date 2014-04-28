//
//  ITPSongPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 27/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPAudioPickerTableViewCell.h"
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
        
        double time = [[[[NSNumberFormatter alloc]init]numberFromString:songObject.trackTimeMillis] doubleValue];
        self.trackTimeLabel.text = [NSString stringWithFormat:@"%i:%i",(int)(fmodf(time , (1000*60*60)) / (1000*60)),(int)(fmodf(fmodf(time , (1000*60*60)) , (1000*60)) / 1000)];
        self.trackExplicitness.text = [songObject.trackExplicitness isEqualToString:kITunesMusicNotExplicit]?@"":NSLocalizedString(@"trackExplicit",nil);
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * priceNumber = [f numberFromString:songObject.trackPrice];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyCode:songObject.currency];
        [formatter setLocale:[NSLocale currentLocale]];
        self.priceLabel.text = [formatter stringFromNumber:priceNumber];
        
        [self.detailButton setTitle:NSLocalizedString(@"itppicker.tablecell.app.button.detail",nil) forState:UIControlStateNormal];
        
        self.genreLabel.text = songObject.primaryGenreName;
        self.musicPlayerView.showActivityIndicator = YES;
        self.musicPlayerView.song = songObject;
        self.musicPlayerView.hidden = NO;        
        self.imageView.hidden = YES;
    }
    else if([ent isKindOfClass:[ACKAlbum class]])
    {
        ACKAlbum* albumObject = (ACKAlbum*)ent;
        self.trackNameLabel.text = albumObject.collectionName;
        self.artistLabel.text = albumObject.artistName;
        self.genreLabel.text = albumObject.primaryGenreName;
        
        self.trackTimeLabel.text = @"";
        self.trackExplicitness.text = [albumObject.collectionExplicitness isEqualToString:kITunesMusicNotExplicit]?@"":NSLocalizedString(@"trackExplicit",nil);
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * priceNumber = [f numberFromString:albumObject.collectionPrice];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyCode:albumObject.currency];
        [formatter setLocale:[NSLocale currentLocale]];
        self.priceLabel.text = [formatter stringFromNumber:priceNumber];
        
        [self.detailButton setTitle:NSLocalizedString(@"itppicker.tablecell.app.button.detail",nil) forState:UIControlStateNormal];
        
        self.genreLabel.text = albumObject.primaryGenreName;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.showActivityIndicator = YES;
        self.imageView.entity = albumObject;
        self.imageView.hidden = NO;
        self.musicPlayerView.hidden = YES;
    }
}

@end
