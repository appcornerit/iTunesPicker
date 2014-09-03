//
//  ITPPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 26/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewCell.h"
#import "ITPGraphic.h"
#import "Chameleon.h"

//#define kColorEntityInUserCountryChart [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:0.5]
//#define kColorEntityNotInTunesUserCountry [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:0.5]

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //external view
//    self.positionLabel.widthMode = LKBadgeViewWidthModeSmall;
    self.positionLabel.textColor = [[ITPGraphic sharedInstance] commonContrastColor];
//    self.positionLabel.badgeColor = [UIColor redColor];
//    self.positionLabel.horizontalAlignment = LKBadgeViewHorizontalAlignmentRight;
    self.positionBackgroundView.backgroundColor = [[ITPGraphic sharedInstance] commonColor];
    self.lineView.backgroundColor = [[ITPGraphic sharedInstance] commonContrastColor];
    
//    [self.slideButton setStyle:kFRDLivelyButtonStyleCirclePlus animated:NO];
////    [self.slideButton addTarget:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.slideButton setOptions:@{ kFRDLivelyButtonLineWidth: @(3.0f),
//                                   kFRDLivelyButtonHighlightedColor: [[ITPGraphic sharedInstance] commonColor],
//                                   kFRDLivelyButtonColor: [[ITPGraphic sharedInstance] commonColor]
//                                   }];
    
}

#pragma mark Action

//- (IBAction)openiTunesStore:(id)sender
//{
//    if(sender == self.detailButton)
//    {
//        UITableView *tableView = (UITableView *)self.superview;
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//            tableView = (UITableView *)tableView.superview;
//        }
//        NSIndexPath *pathOfTheCell = [tableView indexPathForCell:self];
//        if ([tableView.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
//        {
//            [tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:pathOfTheCell];
//        }
//    }
//    else
//    {
//        ACKITunesQuery* query = [[ACKITunesQuery alloc]init];
//        query.cachePolicyChart = NSURLRequestUseProtocolCachePolicy;
//        query.cachePolicyLoadEntity = NSURLRequestUseProtocolCachePolicy;
//        
//        [query openEntity:self.iTunesEntity inITunesStoreCountry:self.userCountry isGift:NO completionBlock:^(BOOL succeeded, NSError *err) {
//            if(!succeeded || err)
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_title_item_not_in_user_country",nil) message:NSLocalizedString(@"error_message_item_not_in_user_country",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"button_cancel",nil), nil];
//                [alert show];
//            }
//        }];
//    }
//}

-(void) setState:(tITunesEntityState)state
{
    switch (state) {
        case kITunesEntityStateNone:
//            self.backgroundColor = [UIColor whiteColor];
//            for (UILabel* label in self.labelViews) {
                self.positionLabel.textColor = [[ITPGraphic sharedInstance] commonContrastColor];
//            }
            break;
        case kITunesEntityStateInUserCountryChart:
//            self.backgroundColor = kColorEntityInUserCountryChart;
//            for (UILabel* label in self.labelViews) {
            self.positionLabel.textColor = FlatGreen; //[[ITPGraphic sharedInstance] commonComplementaryColor];
//            }
            break;
        case kITunesEntityStateNotInTunesUserCountry:
//            self.backgroundColor = kColorEntityNotInTunesUserCountry;
//            for (UILabel* label in self.labelViews) {
                self.positionLabel.textColor = FlatGray;
//            }
            break;
    }
}


-(IBAction) slideCellButtons:(id)sender
{
    if (self.cellState == kCellStateCenter)
    {
        [self showLeftUtilityButtonsAnimated:YES];
//        [self.slideButton setStyle:kFRDLivelyButtonStyleCircleClose animated:YES];
    }
    else
    {
        [self hideUtilityButtonsAnimated:YES];
//        [self.slideButton setStyle:kFRDLivelyButtonStyleCirclePlus animated:YES];
    }
}


@end
