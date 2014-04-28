//
//  ITPPickerTableViewCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewCell.h"

@interface ITPAppPickerTableViewCell : ITPPickerTableViewCell

@property (nonatomic, weak) IBOutlet ACKAppIconImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UIImageView *starImageView;
@property (nonatomic, weak) IBOutlet UILabel *noRatingsLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starAllVersionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingsAllVersionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noRatingsAllVersionsLabel;

@end
