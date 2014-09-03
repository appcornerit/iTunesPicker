//
//  ITPPickerTableViewCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 26/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHRoundBorderedButton.h"
#import "SWTableViewCell.h"

typedef enum {
    kITunesEntityStateNone = 0,
    kITunesEntityStateInUserCountryChart,
    kITunesEntityStateNotInTunesUserCountry,
} tITunesEntityState;

@interface ITPPickerTableViewCell : SWTableViewCell

@property (nonatomic, copy) ACKITunesEntity* iTunesEntity;
@property (nonatomic, copy) NSString *userCountry;
@property (nonatomic, assign) tITunesEntityState state;

@property (nonatomic, weak) IBOutlet UIView *positionBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (nonatomic, weak) IBOutlet UIButton *slideButton;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@property (nonatomic, weak) IBOutlet UIButton *detailButton;
@property (nonatomic, weak) IBOutlet YHRoundBorderedButton *purchaseButton;
@property (nonatomic, weak) IBOutlet UILabel *positionLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *labelViews;

//-(IBAction)openiTunesStore:(id)sender;
-(IBAction)slideCellButtons:(id)sender;

-(void)initCell;

@end
