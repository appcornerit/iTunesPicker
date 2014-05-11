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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
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
    
    switch (indexPath.row) {
        case 0:
        cell.textLabel.text = NSLocalizedString(@"menu.selectcountries", nil);
        break;
        case 1:
        cell.textLabel.text = NSLocalizedString(@"Apps", nil);
        break;
        case 2:
        cell.textLabel.text = NSLocalizedString(@"Music", nil);
        break;
//        case :
//        cell.textLabel.text = NSLocalizedString(@"Video Music", nil);
//        break;
//        case :
//        cell.textLabel.text = NSLocalizedString(@"E-books", nil);
//        break;
//        case :
//        cell.textLabel.text = NSLocalizedString(@"Audiobooks", nil);
//        break;
        case 3:
        cell.textLabel.text = NSLocalizedString(@"Movies", nil);
        break;
//        case :
//        cell.textLabel.text = NSLocalizedString(@"Short film", nil);
//        break;
//        case :
//        cell.textLabel.text = NSLocalizedString(@"TV Show", nil);
//        break;
//        case :
//        cell.textLabel.text = NSLocalizedString(@"Podcast", nil);
//        break;
        case 4:
        cell.textLabel.text = NSLocalizedString(@"menu.changeusercountry", nil);
        cell.imageView.image = [UIImage imageNamed:[self.delegate getUserCountry]];
        break;
//        cell.textLabel.text = NSLocalizedString(@"Help", nil);
//        break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tITunesEntityType selectedType;
    switch (indexPath.row) {
        case 0:
            [self.delegate openCountriesPicker];
        return;
        break;
        case 1:
        selectedType = kITunesEntityTypeSoftware;
        break;
        case 2:
        selectedType = kITunesEntityTypeMusic;
        break;
//        case :
//        selectedType = kITunesEntityTypeMusicVideo;
//        break;
//        case :
//        selectedType = kITunesEntityTypeEBook;
//        break;
//        case :
//        selectedType = kITunesEntityTypeAudiobook;
//        break;
        case 3:
        selectedType = kITunesEntityTypeMovie;
        break;
//        case :
//        selectedType = kITunesEntityTypeShortFilm;
//        break;
//        case :
//        selectedType = kITunesEntityTypeTVShow;
//        break;
//        case :
//        selectedType = kITunesEntityTypePodcast;
//        break;
        case 4:
        [self.delegate openUserCountrySetting];
        return;
        break;
//        case :
//        break;
    }

    [self.delegate iTunesEntityTypeDidSelected:selectedType];
}


@end
