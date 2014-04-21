//
//  ACKBook.h
//  AppCornerKit
//
//  Created by Denis Berton on 12/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKITunesEntity.h"

@interface ACKBook : ACKITunesEntity

@property (nonatomic,strong) NSString* artistId;
@property (nonatomic,strong) NSString* artistName;
@property (nonatomic,strong) NSString* kind;
@property (nonatomic,strong) NSString* price;
@property (nonatomic,strong) NSString* description;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSArray* genres;
@property (nonatomic,strong) NSArray* genreIds;
@property (nonatomic,strong) NSDate* releaseDate;
@property (nonatomic,strong) NSString* trackId;
@property (nonatomic,strong) NSString* trackName;
@property (nonatomic,strong) NSArray* artistIds;
@property (nonatomic,strong) NSString* formattedPrice;
@property (nonatomic,strong) NSString* artworkUrl60;
@property (nonatomic,strong) NSString* artistViewUrl;
@property (nonatomic,strong) NSString* trackCensoredName;
@property (nonatomic,strong) NSNumber* fileSizeBytes;
@property (nonatomic,strong) NSString* artworkUrl100;
@property (nonatomic,strong) NSString* trackViewUrl;
@property (nonatomic,strong) NSNumber* averageUserRating;
@property (nonatomic,strong) NSNumber* userRatingCount;

@end
