//
//  ITPSliderCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 02/06/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSliderCell.h"
#import "ITPGraphic.h"
#import "Chameleon.h"

@implementation ITPSliderCell

- (void)awakeFromNib
{
    [self initSlider];
}

-(void) initSlider
{
    self.slider.delegate = self;
    self.slider.minimumValue = 10;
    self.slider.maximumValue = 200.0;
    self.slider.value = [[NSUserDefaults standardUserDefaults] integerForKey:DEFAULT_ACK_CHART_ITEMS_KEY];
    self.slider.popUpViewCornerRadius = 12.0;
    [self.slider setMaxFractionDigitsDisplayed:0];
    self.slider.popUpViewColor = FlatBlue;
    self.slider.textColor = FlatWhite;
    self.slider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];

    
    self.labelResults.text = NSLocalizedString(@"slidercell.label", nil);
    self.labelResults.textColor = [UIColor whiteColor];
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider;
{
    [self.superview bringSubviewToFront:self];
}

- (IBAction)sliderValueChangedAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:self.slider.value forKey:DEFAULT_ACK_CHART_ITEMS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
