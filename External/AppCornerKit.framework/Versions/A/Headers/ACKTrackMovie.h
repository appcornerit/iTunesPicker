//
//  ACKTrackMovie.h
//  AppCornerKit
//
//  Created by Denis Berton on 12/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKITunesEntity.h"

@interface ACKTrackMovie : ACKITunesEntity

@property (nonatomic,strong) NSString* wrapperType;
@property (nonatomic,strong) NSString* kind;
@property (nonatomic,strong) NSString* trackId;
@property (nonatomic,strong) NSString* artistName;
@property (nonatomic,strong) NSString* trackName;
@property (nonatomic,strong) NSString* trackCensoredName;
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
@property (nonatomic,strong) NSString* trackTimeMillis;
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSString* primaryGenreName;
@property (nonatomic,strong) NSString* contentAdvisoryRating;
@property (nonatomic,strong) NSString* longDescription;
@property (nonatomic,strong) NSString* radioStationUrl;

@end
