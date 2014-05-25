//
//  ITPLeftMenuViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 23/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSideRightMenuViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface ITPSideRightMenuViewController ()

@end

@implementation ITPSideRightMenuViewController

-(NSArray*)getAvailableTypes
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults arrayForKey:DEFAULT_ACK_TYPES_KEY];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section) {
        case 0:
            return [self getAvailableTypes].count;
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
            return NSLocalizedString(@"menu.section.types", nil);
        default:
            return NSLocalizedString(@"menu.section.settings", nil);
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
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.imageView.image = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            NSString* key = [NSString stringWithFormat:@"type_%d",[[self getAvailableTypes][indexPath.row] intValue]];
            cell.textLabel.text = NSLocalizedString(key, nil);
            break;
        }
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"menu.selectcountries", nil);
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"menu.changeusercountry", nil);
                    cell.imageView.image = [UIImage imageNamed:[self.delegate getUserCountry]];
                    break;
            }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tITunesEntityType selectedType;
    
    switch (indexPath.section) {
        case 0:
            selectedType = [[self getAvailableTypes][indexPath.row] intValue];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.delegate openCountriesPicker];
                    return;
                    break;
                case 1:
                    [self.delegate openUserCountrySetting];
                    return;
                    break;
            }
            break;
    }

    [self.delegate iTunesEntityTypeDidSelected:selectedType];
}


@end
