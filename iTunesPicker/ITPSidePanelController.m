//
//  ITPSidePanelController.m
//  iTunesPicker
//
//  Created by Denis Berton on 23/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSidePanelController.h"
#import "ITPViewController.h"
#import "XHPaggingNavbar.h"
#import "FRDLivelyButton.h"
#import "ITPGraphic.h"

@interface ITPSidePanelController ()<MSDynamicsDrawerViewControllerDelegate>
    @property (nonatomic, strong) NSDictionary *paneViewControllerIdentifiers;
    @property (nonatomic, strong) XHPaggingNavbar *paggingNavbar;
    @property (nonatomic, strong) FRDLivelyButton *leftButton;
    @property (nonatomic, strong) FRDLivelyButton *rightButton;
@end

@implementation ITPSidePanelController

- (instancetype)initWithRootController:(MSDynamicsDrawerViewController *)rootViewController
{
    self = [super init];
    if (self) {
        [self initialize:rootViewController];
    }
    return self;
}

- (void)initialize:(MSDynamicsDrawerViewController *)rootViewController
{
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerIdentifiers = @{@(MSPaneViewControllerTypeMain) : @"centerViewController"};
    
    self.dynamicsDrawerViewController = rootViewController;
    self.dynamicsDrawerViewController.delegate = self;
    
    // Add some example stylers
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerParallaxStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler]] forDirection:MSDynamicsDrawerDirectionRight];
    [self.dynamicsDrawerViewController setPaneDragRevealEnabled:NO forDirection:MSDynamicsDrawerDirectionLeft|MSDynamicsDrawerDirectionRight];
    CGFloat openWith = [UIScreen mainScreen].bounds.size.width-50.0;
    [self.dynamicsDrawerViewController setRevealWidth:openWith forDirection:MSDynamicsDrawerDirectionLeft];
    [self.dynamicsDrawerViewController setRevealWidth:openWith forDirection:MSDynamicsDrawerDirectionRight];
    
    ITPSideLeftMenuViewController *leftViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    leftViewController.delegate = self;
    [self.dynamicsDrawerViewController setDrawerViewController:leftViewController forDirection:MSDynamicsDrawerDirectionLeft];
    
    ITPSideRightMenuViewController *rightViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    rightViewController.delegate = self;
    [self.dynamicsDrawerViewController setDrawerViewController:rightViewController forDirection:MSDynamicsDrawerDirectionRight];
    
    // Transition to the first view controller
    [self transitionToViewController:MSPaneViewControllerTypeMain];

    
//    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    titleButton.frame = CGRectMake(0, 0, 200, 40);
//    titleButton.backgroundColor = [UIColor clearColor];
//    [titleButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [titleButton addTarget:self action:@selector(didTapTitleViewAction:) forControlEvents:UIControlEventTouchUpInside];
//    titleButton.hidden = YES;
    
    [self centerViewController].navigationItem.titleView = self.paggingNavbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateACKTypes:) name:NOTIFICATION_CHECK_ACK_TYPES_UPDATED object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action

-(void)didTapTitleViewAction:(id)sender
{
    [ACKITunesQuery cleanCacheExceptTypes:nil];
    [((ITPViewController*)[self centerViewController]) refreshAllPickers];
}

#pragma mark - ITPSideRightMenuViewControllerDelegate

-(void)iTunesEntityTypeDidSelected:(tITunesEntityType)entityType withMediaType:(tITunesMediaEntityType)mediaEntityType
{
    [self updateTitleBarForEntityType:entityType withMediaType:mediaEntityType];
    
    [self transitionToViewController:MSPaneViewControllerTypeMain];
    [((ITPViewController*)[self centerViewController]) reloadWithEntityType:entityType withMediaType:mediaEntityType];
    
//    [[ITPGraphic sharedInstance]setBarCommonColorToNavigationController:((ITPViewController*)[self centerViewController]).navigationController];
}

-(void)openCountriesPicker
{
    if(((ITPViewController*)[self centerViewController]).pickersLoading)
    {
        [self showWaitForLoadingAlert];
    }
    else
    {
        [self transitionToViewController:MSPaneViewControllerTypeMain];
        [((ITPViewController*)[self centerViewController]) openCountriesPicker];
    }

}

-(void) showWaitForLoadingAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_title_waiting_load",nil) message:NSLocalizedString(@"error_message_waiting_load",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"button_cancel",nil), nil];
    [alert show];
}

-(void)openUserCountrySetting
{
    if(((ITPViewController*)[self centerViewController]).pickersLoading)
    {
        [self showWaitForLoadingAlert];
    }
    else
    {
        [self transitionToViewController:MSPaneViewControllerTypeMain];
        [((ITPViewController*)[self centerViewController]) openUserCountryPicker];
    }
}

-(NSString*)getUserCountry
{
  return ((ITPViewController*)[self centerViewController]).entitiesDatasources.userCountry;
}

#pragma mark - ITPSideLeftMenuViewControllerDelegate

-(NSString*)getSelectedFilterLabel:(tITPMenuFilterPanel)menuFilterPanel
{
    return [((ITPViewController*)[self centerViewController]) getSelectedFilterLabel:menuFilterPanel];
}

-(NSInteger)getFilterCountLabels:(tITPMenuFilterPanel)menuFilterPanel
{
    return [((ITPViewController*)[self centerViewController]) getFilterCountLabels:menuFilterPanel];
}

- (void)toggleMenuPanel:(tITPMenuFilterPanel)menuFilterPanel
{
    if([self getFilterCountLabels:menuFilterPanel] >1)
    {
    [self transitionToViewController:MSPaneViewControllerTypeMain];
        [((ITPViewController*)[self centerViewController]) toggleMenuPanel:menuFilterPanel];
    }
}

-(void)openDiscoverView
{
    if(((ITPViewController*)[self centerViewController]).pickersLoading)
    {
        [self showWaitForLoadingAlert];
    }
    else
    {
        [self transitionToViewController:MSPaneViewControllerTypeMain];
        [((ITPViewController*)[self centerViewController]) openDiscoverView];
    }
}

-(void)openGlobalRankingView
{
    if(((ITPViewController*)[self centerViewController]).pickersLoading)
    {
        [self showWaitForLoadingAlert];
    }
    else
    {
        [self transitionToViewController:MSPaneViewControllerTypeMain];
        [((ITPViewController*)[self centerViewController]) openGlobalRankingView];
    }
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
//    if(entityType == kITunesEntityTypeSoftware && mediaEntityType == kITunesMediaEntityTypeDefaultForEntity)
//    {
//        mediaEntityType = kITunesMediaEntityTypeSoftware;
//    }
//    NSString* typeKey = [NSString stringWithFormat:@"type_%d_%d",entityType,mediaEntityType];
//    
//    UIButton* titleButton = ((UIButton*)[self centerViewController].navigationItem.titleView);
//    [titleButton setTitle:NSLocalizedString(typeKey,nil) forState:UIControlStateNormal];
//    titleButton.hidden = NO;
}

-(UIViewController*) centerViewController
{
   return ((UINavigationController*)self.dynamicsDrawerViewController.paneViewController).viewControllers[0];
}

#pragma mark - menu

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType
{
    // Close pane if already displaying the pane view controller
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.dynamicsDrawerViewController.paneViewController != nil;
    
    UIViewController *paneViewController = [self.dynamicsDrawerViewController.storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
    
    //    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    //    self.paneRevealLeftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Left Reveal Icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
//    self.filterBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
    
    self.leftButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,40,22)];
    [self.leftButton setStyle:kFRDLivelyButtonStyleCaretLeft animated:NO];
    [self.leftButton addTarget:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setOptions:@{ kFRDLivelyButtonLineWidth: @(3.0f),
                          kFRDLivelyButtonHighlightedColor: [[ITPGraphic sharedInstance] commonContrastColor],
                          kFRDLivelyButtonColor: [[ITPGraphic sharedInstance] commonContrastColor]
                          }];
    self.filterBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    
    paneViewController.navigationItem.leftBarButtonItem = self.filterBarButtonItem;
    
    //    self.paneRevealRightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Right Reveal Icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(dynamicsDrawerRevealRightBarButtonItemTapped:)];
//    self.menuBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(dynamicsDrawerRevealRightBarButtonItemTapped:)];
    
    self.rightButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,40,22)];
    [self.rightButton setStyle:kFRDLivelyButtonStyleCaretRight animated:NO];
    [self.rightButton addTarget:self action:@selector(dynamicsDrawerRevealRightBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setOptions:@{ kFRDLivelyButtonLineWidth: @(3.0f),
                                   kFRDLivelyButtonHighlightedColor: [[ITPGraphic sharedInstance] commonContrastColor],
                                   kFRDLivelyButtonColor: [[ITPGraphic sharedInstance] commonContrastColor]
                                   }];
    self.menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    paneViewController.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [self.dynamicsDrawerViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:nil];
    [self.leftButton setStyle:kFRDLivelyButtonStyleCaretRight animated:YES];
}

- (void)dynamicsDrawerRevealRightBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionRight animated:YES allowUserInterruption:YES completion:nil];
    [self.rightButton setStyle:kFRDLivelyButtonStyleCaretLeft animated:YES];
}

#pragma mark - MSDynamicsDrawerViewControllerDelegate

- (void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController mayUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction
{
//    NSLog(@"Drawer view controller may update to state `%@` for direction `%@`", [self descriptionForPaneState:paneState], [self descriptionForDirection:direction]);
}

- (void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController didUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction
{
//    NSLog(@"Drawer view controller did update to state `%@` for direction `%@`", [self descriptionForPaneState:paneState], [self descriptionForDirection:direction]);
    
    if(paneState == MSDynamicsDrawerPaneStateOpen)
    {
        if(direction == MSDynamicsDrawerDirectionLeft || direction == MSDynamicsDrawerDirectionRight)
        {
            [((ITPViewController*)[self centerViewController]) toggleMenuPanel:kITPMenuFilterPanelNone];
            [self.dynamicsDrawerViewController setPaneDragRevealEnabled:YES forDirection:MSDynamicsDrawerDirectionLeft|MSDynamicsDrawerDirectionRight];
        }
        if(direction == MSDynamicsDrawerDirectionLeft)
        {
            ((ITPSideLeftMenuViewController*)[self.dynamicsDrawerViewController drawerViewControllerForDirection:MSDynamicsDrawerDirectionLeft]).pickerLoading = ((ITPViewController*)[self centerViewController]).pickersLoading;
            [((ITPSideLeftMenuViewController*)[self.dynamicsDrawerViewController drawerViewControllerForDirection:MSDynamicsDrawerDirectionLeft]).tableView reloadData];
        }
        if(direction == MSDynamicsDrawerDirectionRight)
        {
            ((ITPSideRightMenuViewController*)[self.dynamicsDrawerViewController drawerViewControllerForDirection:MSDynamicsDrawerDirectionRight]).pickerLoading = ((ITPViewController*)[self centerViewController]).pickersLoading;
            [((ITPSideRightMenuViewController*)[self.dynamicsDrawerViewController drawerViewControllerForDirection:MSDynamicsDrawerDirectionRight]).tableView reloadData];
        }
    }
    else
    {
        [self.leftButton setStyle:kFRDLivelyButtonStyleCaretLeft animated:YES];
//        [self.leftButton showUnHighlight];
        [self.rightButton setStyle:kFRDLivelyButtonStyleCaretRight animated:YES];
//        [self.rightButton showUnHighlight];
        [self.dynamicsDrawerViewController setPaneDragRevealEnabled:NO forDirection:MSDynamicsDrawerDirectionLeft|MSDynamicsDrawerDirectionRight];
    }
}

- (NSString *)descriptionForPaneState:(MSDynamicsDrawerPaneState)paneState
{
    switch (paneState) {
        case MSDynamicsDrawerPaneStateOpen:
            return @"MSDynamicsDrawerPaneStateOpen";
        case MSDynamicsDrawerPaneStateClosed:
            return @"MSDynamicsDrawerPaneStateClosed";
        case MSDynamicsDrawerPaneStateOpenWide:
            return @"MSDynamicsDrawerPaneStateOpenWide";
        default:
            return nil;
    }
}

- (NSString *)descriptionForDirection:(MSDynamicsDrawerDirection)direction
{
    switch (direction) {
        case MSDynamicsDrawerDirectionTop:
            return @"MSDynamicsDrawerDirectionTop";
        case MSDynamicsDrawerDirectionLeft:
            return @"MSDynamicsDrawerDirectionLeft";
        case MSDynamicsDrawerDirectionBottom:
            return @"MSDynamicsDrawerDirectionBottom";
        case MSDynamicsDrawerDirectionRight:
            return @"MSDynamicsDrawerDirectionRight";
        default:
            return nil;
    }
}

#pragma mark - nav bar

- (XHPaggingNavbar *)paggingNavbar {
    if (!_paggingNavbar) {
        _paggingNavbar = [[XHPaggingNavbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([self centerViewController].view.bounds) / 2.0, 44)];
        _paggingNavbar.backgroundColor = [UIColor clearColor];
    }
    return _paggingNavbar;
}

@end
