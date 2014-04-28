//
//  ITPSidePanelController.h
//  iTunesPicker
//
//  Created by Denis Berton on 23/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSideMenuViewController.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface ITPSidePanelController : JASidePanelController <ITPSideMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterBarButtonItem;

- (IBAction)menuAction:(id)sender;
- (IBAction)filterAction:(id)sender;
@end
