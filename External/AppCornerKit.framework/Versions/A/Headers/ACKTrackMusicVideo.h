//
//  ACKTrackMusicVideo.h
//  AppCornerKit
//
//  Created by Denis Berton on 01/06/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKITunesEntity.h"

@interface ACKTrackMusicVideo : ACKITunesEntity

@property (nonatomic,strong) NSString* artistId;
@property (nonatomic,strong) NSString* trackName;
@property (nonatomic,strong) NSString* trackCensoredName;
@property (nonatomic,strong) NSURL* artistViewUrl;
@property (nonatomic,strong) NSURL* previewUrl;
@property (nonatomic,strong) NSURL* artworkUrl30;
@property (nonatomic,strong) NSURL* artworkUrl60;
@property (nonatomic,strong) NSURL* artworkUrl100;
@property (nonatomic,strong) NSString* collectionPrice;
@property (nonatomic,strong) NSString* trackPrice;
@property (nonatomic,strong) NSDate* releaseDate;
@property (nonatomic,strong) NSString* collectionExplicitness;
@property (nonatomic,strong) NSString* trackExplicitness;
@property (nonatomic,strong) NSNumber* trackTimeMillis;
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSString* primaryGenreName;
@property (nonatomic,strong) NSURL* radioStationUrl;

@end
