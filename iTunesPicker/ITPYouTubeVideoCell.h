//
//  ITPYouTubeVideoCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 23/08/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface ITPYouTubeVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView * previewImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeStamp;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property(nonatomic, weak) IBOutlet YTPlayerView *playerView;


- (void)setupWithDictionary:(NSDictionary *)dictionary;
//- (void)playVideoWithId:(NSString*)videoId;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;
@end
