//
//  ACKTrack.h
//  AppCornerKit
//
//  Created by Denis Berton on 12/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKITunesEntity.h"

@interface ACKTrackSong : ACKITunesEntity

@property (nonatomic,strong) NSString* artistId;
@property (nonatomic,strong) NSString* collectionName;
@property (nonatomic,strong) NSString* trackName;
@property (nonatomic,strong) NSString* collectionCensoredName;
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
@property (nonatomic,strong) NSNumber* discCount;
@property (nonatomic,strong) NSNumber* discNumber;
@property (nonatomic,strong) NSNumber* trackCount;
@property (nonatomic,strong) NSNumber* trackNumber;
@property (nonatomic,strong) NSNumber* trackTimeMillis;
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSString* primaryGenreName;
@property (nonatomic,strong) NSURL* radioStationUrl;

@end
