//
//  ITPSliderCell.m
//  iTunesPicker
//
//  Created by Denis Berton on 02/06/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSliderCell.h"

@implementation ITPSliderCell

- (void)awakeFromNib
{
    [self initSlider];
}

-(void) initSlider
{
    self.slider.delegate = self;
    self.slider.value = [[NSUserDefaults standardUserDefaults] integerForKey:DEFAULT_ACK_CHART_ITEMS_KEY];
    self.slider.minimumValue = 10;
    self.slider.maximumValue = 200.0;
    self.slider.popUpViewCornerRadius = 12.0;
    [self.slider setMaxFractionDigitsDisplayed:0];
    self.slider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.slider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.slider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    
    self.labelResults.text = NSLocalizedString(@"slidercell.label", nil);
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
