//
//  ITPBookPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 18/05/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPBookPickerTableViewCell.h"

@implementation ITPBookPickerTableViewCell

@synthesize iTunesEntity=_iTunesEntity;

#pragma mark - Property methods
- (void)setITunesEntity:(ACKITunesEntity *)ent
{
    _iTunesEntity = ent;
    ACKBook* bookObject = (ACKBook*)ent;
    self.bookNameLabel.text = bookObject.trackName;
    self.artistLabel.text = bookObject.artistName;
    self.genreLabel.text = [bookObject.genres componentsJoinedByString:@", "];
    self.priceLabel.text = bookObject.formattedPrice;
    self.coverImageView.showActivityIndicator = YES;
    self.coverImageView.entity = bookObject;
}

@end
