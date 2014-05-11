//
//  ITPSideLeftMenuViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 10/05/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSideLeftMenuViewController.h"

@interface ITPSideLeftMenuViewController ()

@end

@implementation ITPSideLeftMenuViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"SideMenuItemCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.imageView.image = nil;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [self.delegate getSelectedFilterLabel:kITPMenuFilterPanelRanking];
            break;
        case 1:
            cell.textLabel.text = [self.delegate getSelectedFilterLabel:kITPMenuFilterPanelGenre];
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"menu.mergedview", nil);
            break;
//        case :
//            cell.textLabel.text = NSLocalizedString(@"menu.pricedrop", nil);
//            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self.delegate toggleMenuPanel:kITPMenuFilterPanelRanking];
            break;
        case 1:
            [self.delegate toggleMenuPanel:kITPMenuFilterPanelGenre];
            break;
        case 2:
            [self.delegate openMergedView];
            break;
//        case :
//            break;
    }
}


@end
