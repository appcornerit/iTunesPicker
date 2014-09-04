//
//  ITPCountryItemChartsViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ITPCountryItemChartsViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style allCountries:(NSArray*)allCountries selectedCountries:(NSSet*)selectedCountries userCountry:(NSString*) userCountry multiSelect:(BOOL)multiSelect isModal:(BOOL)modal;
- (id)initWithStyle:(UITableViewStyle)style allCountries:(NSArray*)allCountries indexCharts:(NSArray*)indexCharts userCountry:(NSString*)uCountry item:(ACKITunesEntity*)item;

@property (nonatomic, copy) void (^completionBlock)(NSArray *selectedCountries);
@property (nonatomic, assign) NSUInteger countriesSelectionLimit;

@end
