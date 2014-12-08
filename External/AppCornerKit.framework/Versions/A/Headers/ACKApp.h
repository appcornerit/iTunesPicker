//
//  ACKApp.h
//  AppCornerKit
//
//  Created by Denis Berton on 11/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKITunesEntity.h"
#import "ACKPriceDrop.h"

@interface ACKApp : ACKITunesEntity

@property (nonatomic,strong) NSArray* features;
@property (nonatomic,strong) NSArray* supportedDevices;
@property (nonatomic,strong) NSNumber* isGameCenterEnabled;
@property (nonatomic,strong) NSURL* artistViewUrl;
@property (nonatomic,strong) NSURL* artworkUrl60;
@property (nonatomic,strong) NSArray* screenshotUrls;
@property (nonatomic,strong) NSArray* ipadScreenshotUrls;
@property (nonatomic,strong) NSString* artworkUrl512;
@property (nonatomic,strong) NSString* artistId;
@property (nonatomic,strong) NSString* price;
@property (nonatomic,strong) NSString* version;
@property (nonatomic,strong) NSString* longDescription;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSArray* genres;
@property (nonatomic,strong) NSArray* genreIds;
@property (nonatomic,strong) NSDate* releaseDate;
@property (nonatomic,strong) NSString* sellerName;
@property (nonatomic,strong) NSString* trackName;
@property (nonatomic,strong) NSString* primaryGenreName;
@property (nonatomic,strong) NSString* primaryGenreId;
@property (nonatomic,strong) NSString* releaseNotes;
@property (nonatomic,strong) NSString* formattedPrice;
@property (nonatomic,strong) NSString* trackCensoredName;
@property (nonatomic,strong) NSString* contentAdvisoryRating;
@property (nonatomic,strong) NSString* artworkUrl100;
@property (nonatomic,strong) NSArray* languageCodesISO2A;
@property (nonatomic,strong) NSNumber* fileSizeBytes;
@property (nonatomic,strong) NSNumber* averageUserRatingForCurrentVersion;
@property (nonatomic,strong) NSNumber* userRatingCountForCurrentVersion;
@property (nonatomic,strong) NSString* trackContentRating;
@property (nonatomic,strong) NSNumber* averageUserRating;
@property (nonatomic,strong) NSNumber* userRatingCount;

@property (nonatomic,strong) ACKPriceDrop* priceDrop;


-(BOOL) isUniversal;

@end
