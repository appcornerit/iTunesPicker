//
//  ITPYouTubeVideoCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 23/08/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPYouTubeVideoCell.h"

@implementation ITPYouTubeVideoCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithDictionary:(NSDictionary *)dictionary {
    [[ACKYouTube sharedInstance] loadYoutubePreview:self.previewImageView fromDictionary:dictionary];
    self.lblTitle.text = dictionary[@"title"];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [[ACKYouTube sharedInstance] stopLoadingYoutubePreview:self.previewImageView];
    self.lblTitle.text = nil;
    self.playerView.hidden = YES;
}

//-(void) playVideoWithId:(NSString*)videoId
//{
//    // For a full list of player parameters, see the documentation for the HTML5 player
//    // at: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5
//    NSDictionary *playerVars = @{
//                                 @"controls" : @0,
//                                 @"playsinline" : @1,
//                                 @"autohide" : @1,
//                                 @"showinfo" : @0,
//                                 @"modestbranding" : @1
//                                 };
////    self.playerView.delegate = self;
////    self.playerView.alpha = 1.0;
//    self.playerView.hidden = NO;
//    [self.playerView loadWithVideoId:videoId playerVars:playerVars];
//}

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view
{
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.previewImageView.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.previewImageView.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.previewImageView.frame = imageRect;
}

@end
