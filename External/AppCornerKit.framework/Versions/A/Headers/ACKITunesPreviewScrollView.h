//
//  ACKITunesPreviewScrollView.h
//  AppCornerKit
//
//  Created by Denis Berton on 18/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACKITunesPreviewScrollView : UIView

@property (nonatomic,strong) ACKITunesEntity* item;

-(UIImage*)getCurrentImage;

@end
