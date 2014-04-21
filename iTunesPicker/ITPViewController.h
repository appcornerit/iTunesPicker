//
//  ITPViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

@protocol ITPViewControllerDelegate <NSObject>
-(ACKEntitiesContainer*)entitiesDatasources;
@optional
-(void)showLoadingHUD:(BOOL)loading;
-(void)selectEntity:(ACKITunesEntity*)entity;
-(void)showPickerAtIndex:(NSInteger)index;
-(void)openITunesEntityDetail:(ACKITunesEntity*)entity pickerCountry:(NSString*)pickerCountry;
@end

@interface ITPViewController : UIViewController <ITPViewControllerDelegate>

@property (nonatomic,strong) ACKEntitiesContainer* entitiesDatasources;
@property (nonatomic,strong) NSMutableArray* pickerViews;

@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *filterSxButton;
@property (weak, nonatomic) IBOutlet UIButton *filterDxButton;

- (IBAction)openUserCountryPicker:(id)sender;
- (IBAction)filterAction:(id)sender;
- (IBAction)countryAction:(id)sender;
- (IBAction)filterSxAction:(id)sender;
- (IBAction)filterDxAction:(id)sender;

@end
