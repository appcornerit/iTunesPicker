//
//  ITPYouTubeViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 16/08/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITPYouTubeVideoCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface ITPYouTubeViewController : UIViewController  <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL loading;
}
@property (strong, nonatomic) NSArray *videosArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
