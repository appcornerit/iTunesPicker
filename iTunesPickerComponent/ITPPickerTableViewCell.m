//
//  ITPPickerTableViewCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 26/04/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewCell.h"
#import "ITPGraphic.h"
#import "Chameleon.h"

@implementation ITPPickerTableViewCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self initCell];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initCell];
    }
    return self;
}

-(void) initCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.positionLabel.textColor = [[ITPGraphic sharedInstance] commonContrastColor];
    self.positionBackgroundView.backgroundColor = [[ITPGraphic sharedInstance] commonColor];
    self.lineView.backgroundColor = [[ITPGraphic sharedInstance] commonContrastColor];
}

#pragma mark Action

-(void) setState:(tITunesEntityState)state
{
    switch (state) {
        case kITunesEntityStateNone:
                self.positionLabel.textColor = [[ITPGraphic sharedInstance] commonContrastColor];
            break;
        case kITunesEntityStateInUserCountryChart:
            self.positionLabel.textColor = FlatGreen;
            break;
        case kITunesEntityStateNotInTunesUserCountry:
                self.positionLabel.textColor = FlatGray;
            break;
    }
}

-(IBAction) slideCellButtons:(id)sender
{
    if (self.cellState == kCellStateCenter)
    {
        [self showLeftUtilityButtonsAnimated:YES];
    }
    else
    {
        [self hideUtilityButtonsAnimated:YES];
    }
}


@end
