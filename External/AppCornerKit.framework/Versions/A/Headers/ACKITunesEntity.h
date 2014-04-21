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
@property (nonatomic,readonly) NSString* country;

-(BOOL) isEqualToEntity:(ACKITunesEntity*)entity;

@end
