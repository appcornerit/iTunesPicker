//
//  ITPAudioPickerTableViewCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 27/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITPPickerTableViewCell.h"

@interface ITPAudioPickerTableViewCell : ITPPickerTableViewCell

@property (nonatomic, weak) IBOutlet ACKImageView *coverImageView;
@property (nonatomic, weak) IBOutlet ACKMusicPlayerView* musicPlayerView;
@property (nonatomic, weak) IBOutlet UILabel *trackNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackExplicitness;

@end
