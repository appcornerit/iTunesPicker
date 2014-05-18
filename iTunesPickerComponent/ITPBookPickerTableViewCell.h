//
//  ITPBookPickerTableViewCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 18/05/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITPPickerTableViewCell.h"

@interface ITPBookPickerTableViewCell : ITPPickerTableViewCell

@property (nonatomic, weak) IBOutlet ACKImageView *coverImageView;
@property (nonatomic, weak) IBOutlet UILabel *bookNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;

@end
