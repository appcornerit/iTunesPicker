//
//  ACKTrackMusicVideoPlayerView.h
//  AppCornerKit
//
//  Created by Denis Berton on 04/05/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACKTrackMusicVideo.h"
#import <MediaPlayer/MediaPlayer.h>

@protocol ACKTrackMusicVideoPlayerDelegate <NSObject>

-(void)presentVideoPlayer:(MPMoviePlayerViewController*)moviePlayerView;

@end

@interface ACKTrackMusicVideoPlayerView : UIImageView

@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, assign) id<ACKTrackMusicVideoPlayerDelegate> delegate;
@property (nonatomic, strong) UIImage* customPlaceholderImage;
@property (nonatomic,strong) ACKTrackMusicVideo* musicVideo;

- (id)initWithFrame:(CGRect)frame musicVideo:(ACKTrackMusicVideo*)musicVideo;

- (IBAction)didTouchUpInside:(id)sender;


@end
