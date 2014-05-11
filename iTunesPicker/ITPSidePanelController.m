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
}

#pragma mark - Action

- (IBAction)menuAction:(id)sender {
    [self toggleRightPanel:sender];
}

- (IBAction)filterAction:(id)sender {
    [self toggleLeftPanel:sender];
}

#pragma mark - ITPSideRightMenuViewControllerDelegate

-(void)iTunesEntityTypeDidSelected:(tITunesEntityType)entityType
{
    [self showCenterPanelAnimated:YES];
    [((ITPViewController*)self.centerPanel) reloadWithEntityType:entityType];
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

- (void)toggleMenuPanel:(tITPMenuFilterPanel)menuFilterPanel
{
    [self showCenterPanelAnimated:YES];    
    return [((ITPViewController*)self.centerPanel) toggleMenuPanel:menuFilterPanel];
}

-(void)openMergedView
{
    [self showCenterPanelAnimated:YES];
    return [((ITPViewController*)self.centerPanel) openMergedView];
}

@end
