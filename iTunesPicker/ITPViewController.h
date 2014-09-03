//
//  ITPViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewControllerDelegate.h"
#import "ITPMenuTableViewController.h"
#import "SwipeView.h"
#import "XHPaggingNavbar.h"
#import <iAd/iAd.h>

typedef enum {
    kITPMenuFilterPanelNone = 0,
    kITPMenuFilterPanelRanking,
    kITPMenuFilterPanelGenre,
} tITPMenuFilterPanel;

@interface ITPViewController : UIViewController <ITPPickerTableViewControllerDelegate>

@property (nonatomic,strong) ACKEntitiesContainer* entitiesDatasources;
@property (nonatomic,strong) NSMutableArray* pickerViews;

@property (nonatomic, weak) IBOutlet ADBannerView *bannerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bannerHeightLayoutConstraint;
@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *swipeViewVerticalSpaceLayoutConstraint;
@property (nonatomic, strong) ITPMenuTableViewController *leftPanel;
@property (nonatomic, strong) ITPMenuTableViewController *rightPanel;
@property (readonly) BOOL pickersLoading;

- (void)refreshAllPickers;
- (void)openUserCountryPicker;
- (void)openCountriesPicker;
- (void)openDiscoverView;
- (void)openGlobalRankingView;
- (void)reloadWithEntityType:(tITunesEntityType)entityType withMediaType:(tITunesMediaEntityType)mediaEntityType;
- (void)toggleMenuPanel:(tITPMenuFilterPanel)menuFilterPanel;

- (NSString*)getSelectedFilterLabel:(tITPMenuFilterPanel)menuFilterPanel;
- (NSInteger)getFilterCountLabels:(tITPMenuFilterPanel)menuFilterPanel;

@end
