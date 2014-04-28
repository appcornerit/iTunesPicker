//
//  ITPCountryItemChartsViewController.m
//  iTunesPicker
//
//  Modified by Denis Berton on 17/02/14.
//
//  Original Version:
//  Created by Dmitry Shmidt on 5/11/13.
//  Copyright (c) 2013 Shmidt Lab. All rights reserved.
//  mail@shmidtlab.com

#import <UIKit/UIKit.h>

@interface ITPCountryItemChartsViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style allCountries:(NSArray*)allCountries selectedCountries:(NSSet*)selectedCountries userCountry:(NSString*) userCountry multiSelect:(BOOL)multiSelect;
- (id)initWithStyle:(UITableViewStyle)style allCountries:(NSArray*)allCountries indexCharts:(NSArray*)indexCharts item:(ACKITunesEntity*)item;

@property (nonatomic, copy) void (^completionBlock)(NSArray *selectedCountries);
@property (nonatomic, assign) NSUInteger countriesSelectionLimit;

@end
