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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightLayoutConstraint;
@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipeViewVerticalSpaceLayoutConstraint;
@property (nonatomic, strong) ITPMenuTableViewController *leftPanel;
@property (nonatomic, strong) ITPMenuTableViewController *rightPanel;

- (void)openUserCountryPicker;
- (void)openCountriesPicker;
- (void)openMergedView;
- (void)reloadWithEntityType:(tITunesEntityType)entityType;
- (void)toggleMenuPanel:(tITPMenuFilterPanel)menuFilterPanel;
- (NSString*)getSelectedFilterLabel:(tITPMenuFilterPanel)menuFilterPanel;

@end
