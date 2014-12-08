//
//  ITPSideMenuViewControllerDelegate.h
//  iTunesPicker
//
//  Created by Denis Berton on 10/05/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITPViewController.h"

@protocol ITPSideRightMenuViewControllerDelegate <NSObject>

-(void)iTunesEntityTypeDidSelected:(tITunesEntityType)entityType withMediaType:(tITunesMediaEntityType)entityMediaType;
-(void)openCountriesPicker;
-(void)openUserCountrySetting;
-(NSString*)getUserCountry;

@end

@protocol ITPSideLeftMenuViewControllerDelegate <NSObject>

- (void)toggleMenuPanel:(tITPMenuFilterPanel)menuFilterPanel;
-(NSString*)getSelectedFilterLabel:(tITPMenuFilterPanel)menuFilterPanel;
-(NSInteger)getFilterCountLabels:(tITPMenuFilterPanel)menuFilterPanel;
-(void)openDiscoverView;
-(void)openGlobalRankingView;
-(BOOL)canShowPriceDrops;
-(void)openPriceDrops;

@end
