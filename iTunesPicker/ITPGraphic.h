//
//  ITPGraphic.h
//  iTunesPicker
//
//  Created by Denis Berton on 24/07/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPGraphic : NSObject

@property (nonatomic,assign) tITunesEntityType iTunesEntityType;

+ (ITPGraphic*)sharedInstance;

- (void) initCommonUXAppearance;
- (void) changeNavBar;
- (UIColor*) commonColor;
- (UIColor*) commonColorForEntity:(tITunesEntityType) iTunesEntityType;
- (UIColor*) commonContrastColor;
- (UIColor*) commonComplementaryColor;

-(void) setBarCommonColorToNavigationController:(UINavigationController*)navigationController;

@end
