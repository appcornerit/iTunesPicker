//
//  ITPPickerTableViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPViewController.h"

@interface ITPPickerTableViewController : UIViewController

@property (nonatomic, weak) id <ITPViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *existsItemsInUserCountry;
@property (nonatomic, strong) NSArray *itemsFounded;
@property (nonatomic,readonly) BOOL loading;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *countryImageView;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)countryAction:(id)sender;

-(void) loadChartInITunesStoreCountry:(NSString*)country withType:(tITunesAppChartType)type withGenre:(tITunesAppGenreType)genre completionBlock:(ACKArrayResultBlock)completion;

-(void) loadEntitiesForArtistId:(NSString *)artistId inAppStoreCountry:(NSString*)country withType:(tITunesEntityType)type completionBlock:(ACKArrayResultBlock)completion;

-(void) selectEnityAtIndex:(NSInteger)index;

@end
