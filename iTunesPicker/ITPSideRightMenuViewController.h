//
//  ITPLeftMenuViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 23/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITPSideMenuViewControllerDelegate.h"

@interface ITPSideRightMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) id<ITPSideRightMenuViewControllerDelegate> delegate;
@property (nonatomic,assign) BOOL pickerLoading;

@end
