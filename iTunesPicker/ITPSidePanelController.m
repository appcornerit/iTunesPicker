//
//  ITPSidePanelController.m
//  iTunesPicker
//
//  Created by Denis Berton on 23/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSidePanelController.h"
#import "ITPViewController.h"
@interface ITPSidePanelController ()

@end

@implementation ITPSidePanelController

-(void) awakeFromNib
{
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    ((ITPSideRightMenuViewController*)self.rightPanel).delegate = self;
    ((ITPSideLeftMenuViewController*)self.leftPanel).delegate = self;
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 200, 40);
    titleButton.backgroundColor = [UIColor clearColor];
    [titleButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(didTapTitleViewAction:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.hidden = YES;
    self.navigationItem.titleView = titleButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateACKTypes:) name:NOTIFICATION_CHECK_ACK_TYPES_UPDATED object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - super implemetation

- (void) statePanelChanged {
    self.filterBarButtonItem.enabled = (self.state != JASidePanelRightVisible);
    self.menuBarButtonItem.enabled = (self.state != JASidePanelLeftVisible);
    if(self.state == JASidePanelLeftVisible || self.state == JASidePanelRightVisible)
    {
        [((ITPViewController*)self.centerPanel) toggleMenuPanel:kITPMenuFilterPanelNone];
    }
    if(self.state == JASidePanelLeftVisible)
    {
        [((ITPSideLeftMenuViewController*)self.leftPanel).tableView reloadData];
    }
    if(self.state == JASidePanelRightVisible)
    {
        [((ITPSideRightMenuViewController*)self.rightPanel).tableView reloadData];
    }
}

#pragma mark - Action

- (IBAction)menuAction:(id)sender {
    [self toggleRightPanel:sender];
}

- (IBAction)filterAction:(id)sender {
    [self toggleLeftPanel:sender];
}

-(void)didTapTitleViewAction:(id)sender
{
    [ACKITunesQuery cleanCacheExceptTypes:nil];
    [((ITPViewController*)self.centerPanel) refreshAllPickers];
}

#pragma mark - ITPSideRightMenuViewControllerDelegate

-(void)iTunesEntityTypeDidSelected:(tITunesEntityType)entityType withMediaType:(tITunesMediaEntityType)mediaEntityType
{
    [self updateTitleBarForEntityType:entityType withMediaType:mediaEntityType];
    [self showCenterPanelAnimated:YES];
    [((ITPViewController*)self.centerPanel) reloadWithEntityType:entityType withMediaType:mediaEntityType];
}

-(void)openCountriesPicker
{
    [self showCenterPanelAnimated:YES];
    [((ITPViewController*)self.centerPanel) openCountriesPicker];
}

-(void)openUserCountrySetting
{
    [self showCenterPanelAnimated:YES];
    [((ITPViewController*)self.centerPanel) openUserCountryPicker];
}

-(NSString*)getUserCountry
{
  return ((ITPViewController*)self.centerPanel).entitiesDatasources.userCountry;
}

#pragma mark - ITPSideLeftMenuViewControllerDelegate

-(NSString*)getSelectedFilterLabel:(tITPMenuFilterPanel)menuFilterPanel
{
    return [((ITPViewController*)self.centerPanel) getSelectedFilterLabel:menuFilterPanel];
}

-(NSInteger)getFilterCountLabels:(tITPMenuFilterPanel)menuFilterPanel
{
    return [((ITPViewController*)self.centerPanel) getFilterCountLabels:menuFilterPanel];
}

- (void)toggleMenuPanel:(tITPMenuFilterPanel)menuFilterPanel
{
    if([self getFilterCountLabels:menuFilterPanel] >1)
    {
        [self showCenterPanelAnimated:YES];
        [((ITPViewController*)self.centerPanel) toggleMenuPanel:menuFilterPanel];
    }
}

-(void)openDiscoverView
{
    [self showCenterPanelAnimated:YES];
    return [((ITPViewController*)self.centerPanel) openDiscoverView];
}

-(void)openGlobalRankingView
{
    [self showCenterPanelAnimated:YES];
    return [((ITPViewController*)self.centerPanel) openGlobalRankingView];
}

#pragma mark - Notifications

-(void)updateACKTypes:(NSNotification*)notification
{
  NSNumber* entityType = [notification.userInfo objectForKey:NOTIFICATION_PARAM_ENTITY_TYPE];
  NSNumber* mediaType = [notification.userInfo objectForKey:NOTIFICATION_PARAM_ENTITY_MEDIA_TYPE];
  [self updateTitleBarForEntityType:[entityType integerValue] withMediaType:[mediaType integerValue]];
}

#pragma mark - private

-(void) updateTitleBarForEntityType:(tITunesEntityType) entityType withMediaType:(tITunesMediaEntityType)mediaEntityType
{
    if(entityType == kITunesEntityTypeSoftware && mediaEntityType == kITunesMediaEntityTypeDefaultForEntity)
    {
        mediaEntityType = kITunesMediaEntityTypeSoftware;
    }
    NSString* typeKey = [NSString stringWithFormat:@"type_%d_%d",entityType,mediaEntityType];
    UIButton* titleButton = ((UIButton*)self.navigationItem.titleView);
    [titleButton setTitle:NSLocalizedString(typeKey,nil) forState:UIControlStateNormal];
    titleButton.hidden = NO;
}

@end
