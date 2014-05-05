//
//  ACKAlbum.h
//  AppCornerKit
//
//  Created by Denis Berton on 12/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKITunesEntity.h"

@interface ACKAlbum : ACKITunesEntity

@property (nonatomic,strong) NSString* collectionType;
@property (nonatomic,strong) NSString* artistId;
@property (nonatomic,strong) NSString* amgArtistId;
@property (nonatomic,strong) NSString* collectionName;
@property (nonatomic,strong) NSString* collectionCensoredName;
@property (nonatomic,strong) NSString* artistViewUrl;
@property (nonatomic,strong) NSURL* artworkUrl60;
@property (nonatomic,strong) NSURL* artworkUrl100;
@property (nonatomic,strong) NSString* collectionPrice;
@property (nonatomic,strong) NSString* collectionExplicitness;
@property (nonatomic,strong) NSNumber* trackCount;
@property (nonatomic,strong) NSString* copyright;
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSDate* releaseDate;
@property (nonatomic,strong) NSString* primaryGenreName;

@end
