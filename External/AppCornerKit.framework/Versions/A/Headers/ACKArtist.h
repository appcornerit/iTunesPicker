//
//  ACKArtist.h
//  AppCornerKit
//
//  Created by Denis Berton on 12/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKITunesEntity.h"

@interface ACKArtist : ACKITunesEntity

@property (nonatomic,strong) NSString* wrapperType;
@property (nonatomic,strong) NSString* artistType;
@property (nonatomic,strong) NSString* artistName;
@property (nonatomic,strong) NSString* artistLinkUrl;
@property (nonatomic,strong) NSString* artistId;
@property (nonatomic,strong) NSString* amgArtistId;
@property (nonatomic,strong) NSString* primaryGenreName;
@property (nonatomic,strong) NSNumber* primaryGenreId;
@property (nonatomic,strong) NSString* radioStationUrl;

@end
