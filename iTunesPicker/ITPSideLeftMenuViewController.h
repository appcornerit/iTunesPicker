//
//  ITPSideLeftMenuViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 10/05/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITPSideMenuViewControllerDelegate.h"

@interface ITPSideLeftMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) id<ITPSideLeftMenuViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic,assign) BOOL pickerLoading;

@end
