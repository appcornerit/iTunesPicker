//
//  ITPPickerTableViewCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

@interface ITPPickerTableViewCell : UITableViewCell

@property (nonatomic, copy) ACKApp *appObject;
@property (nonatomic, copy) NSString *userCountry;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet ACKAppIconImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UIImageView *starImageView;
@property (nonatomic, weak) IBOutlet UILabel *noRatingsLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingsLabel;
@property (nonatomic, weak) IBOutlet UIButton *detailButton;
@property (nonatomic, strong)  UIImageView *separatorImage;
@property (weak, nonatomic) IBOutlet UIView *backgroundViewButtonDetail;
@property (weak, nonatomic) IBOutlet UIView *backgroundButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *starAllVersionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingsAllVersionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noRatingsAllVersionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

- (IBAction)openiTunesStore:(id)sender;

@end
