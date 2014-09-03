//
//  ACKYouTube.h
//  AppCornerKit
//
//  Created by Denis Berton on 16/08/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void (^SearchBlock)(NSError *error, NSArray* result);
#define MAX_YOUTUBE_SEARCH_LIMIT 50

@interface ACKYouTube : NSObject

+ (ACKYouTube*)sharedInstance;

- (void)performVideoSearchForITunesEntity:(ACKITunesEntity*)iTunesEntity limit:(NSInteger)limit country:(NSString*)country APIKey:(NSString*)APIKey completion:(SearchBlock)block;

- (void)loadYoutubePreview:(UIImageView*)imageView fromDictionary:(NSDictionary*)dict;
- (void)stopLoadingYoutubePreview:(UIImageView*)image;

- (MPMoviePlayerViewController*)playerVideoWithId:(NSString*)videoId;

@end
