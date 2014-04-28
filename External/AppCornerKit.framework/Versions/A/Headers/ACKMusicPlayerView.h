//
//  ACKMusicPlayerView.h
//  AppCornerKit
//
//  Created by Denis Berton on 27/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACKTrackSong.h"

@interface ACKMusicPlayerView : UIView

@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, strong) UIImage* customPlaceholderImage;
@property (nonatomic,strong) ACKTrackSong* song;

- (id)initWithFrame:(CGRect)frame song:(ACKTrackSong*)song;

- (IBAction)didTouchUpInside:(id)sender;

@end
