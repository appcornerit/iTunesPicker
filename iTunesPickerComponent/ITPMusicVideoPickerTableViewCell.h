//
//  ITPMusicVideoPickerTableViewCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 01/06/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITPPickerTableViewCell.h"

@interface ITPMusicVideoPickerTableViewCell : ITPPickerTableViewCell

@property (nonatomic, weak) IBOutlet ACKTrackMusicVideoPlayerView *coverImageView;
@property (nonatomic, weak) IBOutlet UILabel *trackNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackExplicitness;

@end
