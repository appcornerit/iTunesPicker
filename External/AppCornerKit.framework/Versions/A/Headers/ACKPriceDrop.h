//
//  ACKPriceDrop.h
//  AppCornerKit
//
//  Created by Denis Berton on 07/12/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

@interface ACKPriceDrop : NSObject

@property (nonatomic,strong) NSString* appCode;
@property (nonatomic,strong) NSNumber* fromPrice;
@property (nonatomic,strong) NSNumber* toPrice;
@property (nonatomic,strong) NSDate* priceDropDate;

@end
