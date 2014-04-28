//
//  ITPViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewControllerDelegate.h"

@interface ITPViewController : UIViewController <ITPPickerTableViewControllerDelegate>

@property (nonatomic,strong) ACKEntitiesContainer* entitiesDatasources;
@property (nonatomic,strong) NSMutableArray* pickerViews;

@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *filterSxButton;
@property (weak, nonatomic) IBOutlet UIButton *filterDxButton;

- (IBAction)openUserCountryPicker:(id)sender;
- (IBAction)toggleFilter:(id)sender;
- (IBAction)countryAction:(id)sender;
- (IBAction)filterSxAction:(id)sender;
- (IBAction)filterDxAction:(id)sender;

- (void)reloadWithEntityType:(tITunesEntityType)entityType;

@end
