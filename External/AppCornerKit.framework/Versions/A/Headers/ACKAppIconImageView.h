//
//  ACKAppIconImageView.h
//  AppCornerKit
//
//  Created by Denis Berton on 18/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

@class ACKApp;

@interface ACKAppIconImageView : UIImageView

@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, strong) UIImage* customPlaceholderImage;
@property (nonatomic,strong) ACKApp* app;

- (id)initWithFrame:(CGRect)frame app:(ACKApp*)app;

@end
