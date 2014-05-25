//
//  ITPPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 26/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewCell.h"

#define kColorEntityInUserCountryChart [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:0.5]
#define kColorEntityNotInTunesUserCountry [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:0.5]

@implementation ITPPickerTableViewCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self initCell];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initCell];
    }
    return self;
}

-(void) initCell
{
    //external view
    self.positionBadge.widthMode = LKBadgeViewWidthModeSmall;
    self.positionBadge.textColor = [UIColor whiteColor];
    self.positionBadge.badgeColor = [UIColor redColor];
    self.positionBadge.horizontalAlignment = LKBadgeViewHorizontalAlignmentRight;
}

#pragma mark Action

- (IBAction)openiTunesStore:(id)sender
{
    if(sender == self.detailButton)
    {
        UITableView *tableView = (UITableView *)self.superview;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            tableView = (UITableView *)tableView.superview;
        }
        NSIndexPath *pathOfTheCell = [tableView indexPathForCell:self];
        if ([tableView.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        {
            [tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:pathOfTheCell];
        }
    }
    else
    {
        ACKITunesQuery* query = [[ACKITunesQuery alloc]init];
        query.cachePolicyChart = NSURLRequestUseProtocolCachePolicy;
        query.cachePolicyLoadEntity = NSURLRequestUseProtocolCachePolicy;
        
        [query openEntity:self.iTunesEntity inITunesStoreCountry:self.userCountry isGift:NO completionBlock:^(BOOL succeeded, NSError *err) {
            if(!succeeded || err)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_title_item_not_in_user_country",nil) message:NSLocalizedString(@"error_message_item_not_in_user_country",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"button_cancel",nil), nil];
                [alert show];
            }
        }];
    }
}

-(void) setState:(tITunesEntityState)state
{
    switch (state) {
        case kITunesEntityStateNone:
            self.backgroundColor = [UIColor whiteColor];
            for (UILabel* label in self.labelViews) {
                label.textColor = [UIColor grayColor];
            }
            break;
        case kITunesEntityStateInUserCountryChart:
            self.backgroundColor = kColorEntityInUserCountryChart;
            for (UILabel* label in self.labelViews) {
                label.textColor = [UIColor whiteColor];
            }
            break;
        case kITunesEntityStateNotInTunesUserCountry:
            self.backgroundColor = kColorEntityNotInTunesUserCountry;
            for (UILabel* label in self.labelViews) {
                label.textColor = [UIColor whiteColor];
            }
            break;
    }
}

@end
