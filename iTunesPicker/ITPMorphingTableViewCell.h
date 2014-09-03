//
//  ITPMorphingCellTableViewCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 07/08/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOMSMorphingLabel.h"

@interface ITPMorphingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *morphLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic) IBOutlet UIView *typeView;

@end
