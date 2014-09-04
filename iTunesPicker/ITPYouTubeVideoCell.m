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
}

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
