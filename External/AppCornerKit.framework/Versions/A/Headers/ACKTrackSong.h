//
//  ACKTrack.h
//  AppCornerKit
//
//  Created by Denis Berton on 12/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKITunesEntity.h"

@interface ACKTrackSong : ACKITunesEntity

@property (nonatomic,strong) NSString* wrapperType;
@property (nonatomic,strong) NSString* kind;
@property (nonatomic,strong) NSString* artistId;
@property (nonatomic,strong) NSString* artistName;
@property (nonatomic,strong) NSString* collectionName;
@property (nonatomic,strong) NSString* trackName;
@property (nonatomic,strong) NSString* collectionCensoredName;
@property (nonatomic,strong) NSString* trackCensoredName;
@property (nonatomic,strong) NSString* artistViewUrl;
@property (nonatomic,strong) NSString* collectionViewUrl;
@property (nonatomic,strong) NSString* trackViewUrl;
@property (nonatomic,strong) NSString* previewUrl;
@property (nonatomic,strong) NSString* artworkUrl30;
@property (nonatomic,strong) NSString* artworkUrl60;
@property (nonatomic,strong) NSString* artworkUrl100;
@property (nonatomic,strong) NSString* collectionPrice;
@property (nonatomic,strong) NSString* trackPrice;
@property (nonatomic,strong) NSDate* releaseDate;
@property (nonatomic,strong) NSString* collectionExplicitness;
@property (nonatomic,strong) NSString* trackExplicitness;
@property (nonatomic,strong) NSString* discCount;
@property (nonatomic,strong) NSString* discNumber;
@property (nonatomic,strong) NSString* trackCount;
@property (nonatomic,strong) NSString* trackNumber;
@property (nonatomic,strong) NSString* trackTimeMillis;
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSString* primaryGenreName;
@property (nonatomic,strong) NSString* radioStationUrl;

@end
