//
//  ACKImageView.h
//  AppCornerKit
//
//  Created by Denis Berton on 28/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACKITunesEntity.h"

@interface ACKImageView : UIImageView

@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, strong) UIImage* customPlaceholderImage;
@property (nonatomic,strong) ACKITunesEntity* entity;

- (id)initWithFrame:(CGRect)frame app:(ACKITunesEntity*)entity;

@end
