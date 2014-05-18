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
    switch (section) {
        case 0:
            return 2;
        default:
            return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"menu.section.filters", nil);
        default:
            return NSLocalizedString(@"menu.section.views", nil);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
    }
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

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [self.delegate getSelectedFilterLabel:kITPMenuFilterPanelRanking];
                    break;
                case 1:
                    cell.textLabel.text = [self.delegate getSelectedFilterLabel:kITPMenuFilterPanelGenre];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"menu.discoverview", nil);
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"menu.globalrankingview", nil);
                    break;
//                case :
//                    cell.textLabel.text = NSLocalizedString(@"menu.pricedrop", nil);
//                    break;
            }
            break;            
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self.delegate toggleMenuPanel:kITPMenuFilterPanelRanking];
                    break;
                case 1:
                    [self.delegate toggleMenuPanel:kITPMenuFilterPanelGenre];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.delegate openDiscoverView];
                    break;
                case 1:
                    [self.delegate openGlobalRankingView];
                    break;
//                case :
//                    break;
            }
            break;
    }
}


@end
