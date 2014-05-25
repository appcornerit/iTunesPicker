//
//  ACKITunesItem.h
//  AppCornerKit
//
//  Created by Denis Berton on 11/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKConstants.h"

@interface ACKITunesEntity : NSObject

@property (nonatomic,readonly) tITunesEntityType iTunesEntityType;
@property (nonatomic,readonly) tITunesMediaEntityType iTunesMediaEntityType; //seach term only
@property (nonatomic,readonly) NSString* country;
@property (nonatomic,readonly) NSUInteger order; //position in ranking or order in search term
@property (nonatomic,readonly) NSString* artistName;
@property (nonatomic,readonly) BOOL existInUserCountry; //assigned only with ACKITunesQuery userCountry

@property (nonatomic,strong) id userData; //user data to passing custom data in ACKITunesEntity

-(BOOL) isEqualToEntity:(ACKITunesEntity*)entity;

@end
