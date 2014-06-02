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
#import "ITPSliderCell.h"

static NSString *CellIdentifierSlider = @"ITPSliderCell";
static NSString *CellIdentifierMenu = @"SideMenuItemCell";

@interface ITPSideRightMenuViewController ()

@end

@implementation ITPSideRightMenuViewController

//-(void) viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [self.tableView registerClass:[ITPSliderCell class] forCellReuseIdentifier:CellIdentifierSlider];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifierMenu];
//}

-(NSArray*)getAvailableTypes
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults arrayForKey:DEFAULT_ACK_TYPES_KEY];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section) {
        case 0:
        {
            NSInteger count = [self getAvailableTypes].count;
            if([[self getAvailableTypes] containsObject:@(kITunesEntityTypeSoftware)])
            {
                count += 2; //add iPad and Mac apps
            }
            return count;
        }
        default:
            return 3;
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
    UITableViewCell *cell = nil;
    if(indexPath.section == 1 && indexPath.row == 2)
    {
//        NSString *CellIdentifier = @"SliderCell";
        cell = (ITPSliderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierSlider];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifierSlider owner:self options:nil]objectAtIndex:0];
        }
    }
    else
    {
//        NSString *CellIdentifier = @"SideMenuItemCell";
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierMenu];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierMenu];
        }
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.imageView.image = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            NSInteger index = indexPath.row;
            tITunesMediaEntityType selectedMediaType = kITunesMediaEntityTypeDefaultForEntity;
            
            //add iPad and Mac apps
            if([[self getAvailableTypes] containsObject:@(kITunesEntityTypeSoftware)])
            {
                index = [[self getAvailableTypes] indexOfObject:@(kITunesEntityTypeSoftware)];
                if(indexPath.row >= index && indexPath.row <= index+2)
                {
                    NSInteger mediaTypeIndex = indexPath.row - index;
                    switch (mediaTypeIndex) {
                        case 0:
                            selectedMediaType = kITunesMediaEntityTypeSoftware;
                            break;
                        case 1:
                            selectedMediaType = kITunesMediaEntityTypeSoftwareiPad;
                            break;
                        case 2:
                            selectedMediaType = kITunesMediaEntityTypeSoftwareMac;
                            break;
                    }
                }
                else if(indexPath.row > index+2)
                {
                    index = indexPath.row - 2;
                }
            }
            
            NSString* key = [NSString stringWithFormat:@"type_%d_%d",[[self getAvailableTypes][index] intValue],selectedMediaType];
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
                case 2:
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
    tITunesMediaEntityType selectedMediaType = kITunesMediaEntityTypeDefaultForEntity;
    
    switch (indexPath.section) {
        case 0:
        {
            NSInteger index = indexPath.row;
            
            //add iPad and Mac apps
            if([[self getAvailableTypes] containsObject:@(kITunesEntityTypeSoftware)])
            {
                index = [[self getAvailableTypes] indexOfObject:@(kITunesEntityTypeSoftware)];
                if(indexPath.row >= index && indexPath.row <= index+2)
                {
                    NSInteger mediaTypeIndex = indexPath.row - index;
                    switch (mediaTypeIndex) {
                        case 0:
                            selectedMediaType = kITunesMediaEntityTypeSoftware;
                            break;
                        case 1:
                            selectedMediaType = kITunesMediaEntityTypeSoftwareiPad;
                            break;
                        case 2:
                            selectedMediaType = kITunesMediaEntityTypeSoftwareMac;
                            break;
                    }
                }
                else if(indexPath.row > index+2)
                {
                    index = indexPath.row - 2;
                }
            }
            
            selectedType = [[self getAvailableTypes][index] intValue];
            break;
        }
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.delegate openCountriesPicker];
                    break;
                case 1:
                    [self.delegate openUserCountrySetting];
                    break;
                case 2:
                    break;
            }
            return;
            break;
    }

    [self.delegate iTunesEntityTypeDidSelected:selectedType withMediaType:selectedMediaType];
}


@end
