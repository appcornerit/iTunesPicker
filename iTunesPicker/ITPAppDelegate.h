//
//  ITPAppDelegate.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITPSidePanelController.h"

@interface ITPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ITPSidePanelController* panelController;
@property (assign, nonatomic) BOOL allowOrientation;

@end
