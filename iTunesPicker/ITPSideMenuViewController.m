//
//  ITPLeftMenuViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 23/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSideMenuViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface ITPSideMenuViewController ()

@end

@implementation ITPSideMenuViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"SideMenuItemCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.imageView.image = nil;
    
    switch (indexPath.row) {
        case 0:
        cell.textLabel.text = NSLocalizedString(@"Apps", nil);
        cell.textLabel.textColor = [UIColor greenColor];
        break;
        case 1:
        cell.textLabel.text = NSLocalizedString(@"Music", nil);
        cell.textLabel.textColor = [UIColor greenColor];
        break;
        case 2:
        cell.textLabel.text = NSLocalizedString(@"Video Music", nil);
        break;
        case 3:
        cell.textLabel.text = NSLocalizedString(@"E-books", nil);
        break;
        case 4:
        cell.textLabel.text = NSLocalizedString(@"Audiobooks", nil);
        break;
        case 5:
        cell.textLabel.text = NSLocalizedString(@"Movies", nil);
        cell.textLabel.textColor = [UIColor greenColor];            
        break;
        case 6:
        cell.textLabel.text = NSLocalizedString(@"Short film", nil);
        break;
        case 7:
        cell.textLabel.text = NSLocalizedString(@"TV Show", nil);
        break;
        case 8:
        cell.textLabel.text = NSLocalizedString(@"Podcast", nil);
        break;
        default:
        cell.textLabel.text = NSLocalizedString(@"Change your country", nil);
        cell.imageView.image = [UIImage imageNamed:[self.delegate getUserCountry]];
        break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tITunesEntityType selectedType;
    switch (indexPath.row) {
        case 0:
        selectedType = kITunesEntityTypeSoftware;
        break;
        case 1:
        selectedType = kITunesEntityTypeMusic;
        break;
        case 2:
        selectedType = kITunesEntityTypeMusicVideo;
        break;
        case 3:
        selectedType = kITunesEntityTypeEBook;
        break;
        case 4:
        selectedType = kITunesEntityTypeAudiobook;
        break;
        case 5:
        selectedType = kITunesEntityTypeMovie;
        break;
        case 6:
        selectedType = kITunesEntityTypeShortFilm;
        break;
        case 7:
        selectedType = kITunesEntityTypeTVShow;
        break;
        case 8:
        selectedType = kITunesEntityTypePodcast;
        break;
        default:
        [self.delegate openUserCountrySetting];
        return;
        break;
    }

    [self.delegate iTunesEntityTypeDidSelected:selectedType];
}


@end
