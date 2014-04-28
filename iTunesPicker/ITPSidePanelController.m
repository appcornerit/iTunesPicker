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
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    ((ITPSideMenuViewController*)self.rightPanel).delegate = self;
}

- (IBAction)menuAction:(id)sender {
    [self toggleRightPanel:sender];
}

- (IBAction)filterAction:(id)sender {
    [((ITPViewController*)self.centerPanel)toggleFilter:sender];
}

- (void) statePanelChanged {
    self.filterBarButtonItem.enabled = (self.state != JASidePanelRightVisible);
}


-(void)iTunesEntityTypeDidSelected:(tITunesEntityType)entityType
{
    [self showCenterPanelAnimated:YES];
    [((ITPViewController*)self.centerPanel) reloadWithEntityType:entityType];
}

-(void)openUserCountrySetting
{
    [self showCenterPanelAnimated:YES];
    [((ITPViewController*)self.centerPanel) openUserCountryPicker:nil];
}

-(NSString*)getUserCountry
{
  return ((ITPViewController*)self.centerPanel).entitiesDatasources.userCountry;
}

@end
