//
//  ITPPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 26/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewCell.h"

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
        
        [query openEntity:self.iTunesEntity inITunesStoreCountry:self.userCountry completionBlock:^(BOOL succeeded, NSError *err) {
            if(!succeeded || err)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error open iTunes Store",nil) message:NSLocalizedString(@"The selected item not exits in your country",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Cancel",nil), nil];
                [alert show];
            }
        }];
    }
}

@end
