//
//  ITPSidePanelController.h
//  iTunesPicker
//
//  Created by Denis Berton on 23/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSideRightMenuViewController.h"
#import "ITPSideLeftMenuViewController.h"

#import "MSDynamicsDrawerViewController.h"

typedef NS_ENUM(NSUInteger, MSPaneViewControllerType) {
    MSPaneViewControllerTypeMain
};


@interface ITPSidePanelController : NSObject <ITPSideRightMenuViewControllerDelegate,ITPSideLeftMenuViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBarButtonItem;

@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (nonatomic, assign) MSPaneViewControllerType paneViewControllerType;

- (instancetype)initWithRootController:(MSDynamicsDrawerViewController *)rootViewController;

@end
