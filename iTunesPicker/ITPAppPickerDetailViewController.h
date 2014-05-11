//
//  ITPPickerDetailViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 24/03/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITPPickerTableViewControllerDelegate.h"
#import "SwipeView.h"
#import "YHRoundBorderedButton.h"

@interface ITPAppPickerDetailViewController : UIViewController

@property (nonatomic, strong) ACKApp *appObject;
@property (nonatomic, strong) NSString* pickerCountry;
@property (nonatomic, assign) BOOL allowsSelection;

@property (nonatomic, weak) id <ITPPickerTableViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet ACKAppIconImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UIImageView *starImageView;
@property (nonatomic, weak) IBOutlet UILabel *noRatingsLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingsLabel;
@property (nonatomic, weak) IBOutlet YHRoundBorderedButton *purchaseButton;
@property (nonatomic, strong)  UIImageView *separatorImage;
@property (weak, nonatomic) IBOutlet UIView *backgroundViewButtonDetail;
@property (weak, nonatomic) IBOutlet UIView *backgroundButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *starAllVersionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingsAllVersionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noRatingsAllVersionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet ACKITunesPreviewScrollView *previewScrollView;
@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)openiTunesStore:(id)sender;

@end
