//
//  ITPGraphic.m
//  iTunesPicker
//
//  Created by Denis Berton on 24/07/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPGraphic.h"
#import "Chameleon.h"

@interface ITPGraphic()

@end

@implementation ITPGraphic

+ (ITPGraphic*)sharedInstance
{
    static ITPGraphic *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ITPGraphic alloc] init];
    });
    return _sharedInstance;
}

- (void) initCommonUXAppearance
{
    [[UIToolbar appearance]setTintColor:[self commonContrastColor]];
    [[UINavigationBar appearance] setTintColor:[self commonContrastColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [self commonContrastColor]}];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[self commonContrastColor]];
    [[UISearchBar appearance] setTintColor:[self commonContrastColor]];
    [[UISearchBar appearance] setBarTintColor:[self commonColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[self commonContrastColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void) changeNavBar
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor: [UIColor blueColor]];
}

-(void) setITunesEntityType:(tITunesEntityType)iTunesEntityType
{
    _iTunesEntityType = iTunesEntityType;
    [UIView animateWithDuration:0.2 animations:^{
        [self initCommonUXAppearance];
    }];
}

- (UIColor*) commonColorForEntity:(tITunesEntityType) iTunesEntityType
{
    switch (iTunesEntityType) {
        case kITunesEntityTypeMusic:
            return [UIColor flatRedColor];
            break;
        case kITunesEntityTypeMovie:
            return [UIColor flatBlackColor];
            break;
        case kITunesEntityTypeMusicVideo:
            return [UIColor flatPurpleColor];
            break;
        case kITunesEntityTypeEBook:
            return [UIColor flatBrownColor];
            break;
        case kITunesEntityTypeSoftware:
            return [UIColor flatBlueColor];
            break;
        default:
            return [UIColor flatBlueColor];
            break;
    }
}

- (UIColor*) commonColor
{
    return [[self commonColorForEntity:self.iTunesEntityType] copy];
}

- (UIColor*) commonContrastColor
{
    return [[UIColor colorWithContrastingBlackOrWhiteColorOn:[self commonColor]] copy];
}

- (UIColor*) commonComplementaryColor
{
    return [UIColor colorWithComplementaryFlatColorOf:[self commonColor]];
}

-(void) setBarCommonColorToNavigationController:(UINavigationController*)navigationController
{
    navigationController.navigationBar.barTintColor = [self commonColor];
}

@end
