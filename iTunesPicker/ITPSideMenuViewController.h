//
//  ITPLeftMenuViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 23/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ITPSideMenuViewControllerDelegate <NSObject>

-(void)iTunesEntityTypeDidSelected:(tITunesEntityType)entityType;
-(void)openUserCountrySetting;
-(NSString*)getUserCountry;

@end

@interface ITPSideMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) id<ITPSideMenuViewControllerDelegate> delegate;

@end
