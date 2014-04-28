//
//  ITPPickerTableViewCell.h
//  iTunesPicker
//
//  Created by Denis Berton on 26/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITPPickerTableViewCell : UITableViewCell

@property (nonatomic, copy) ACKITunesEntity* iTunesEntity;
@property (nonatomic, copy) NSString *userCountry;

@property (nonatomic, weak) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

-(IBAction)openiTunesStore:(id)sender;

-(void)initCell;

@end
