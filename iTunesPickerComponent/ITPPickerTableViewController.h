//
//  ITPPickerTableViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPPickerTableViewControllerDelegate.h"
#import "UIScrollView+EmptyDataSet.h"
#import "TTUITableViewZoomController.h"

typedef enum {
    kITPLoadStateRanking = 0,
    kITPLoadStateArtist,
    kITPLoadStateSearchTerms,
    kITPLoadStateExternalEntities,
} tITPLoadState;

@interface ITPPickerTableViewController : TTUITableViewZoomController  <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) id <ITPPickerTableViewControllerDelegate> delegate;

@property (nonatomic, readonly) NSArray *itemsArray; //results of search terms or showEntities array
@property (nonatomic, readonly) NSString* country;
@property (nonatomic, readonly) tITPLoadState loadState;
@property (nonatomic, readonly) BOOL loading;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

-(void) closeAllCells;

-(void) loadChartInITunesStoreCountry:(NSString*)country withType:(NSUInteger)type withGenre:(NSUInteger)genre completionBlock:(ACKArrayResultBlock)completion;
-(void) loadEntitiesForArtistId:(NSString *)artistId inITunesCountry:(NSString*)country withType:(tITunesEntityType)type completionBlock:(ACKArrayResultBlock)completion;
-(void) showEntities:(NSArray*)array keepEntitiesNotInCountry:(BOOL)keepEntitiesNotInCountry highlightCells:(BOOL)highlightCells completionBlock:(ACKArrayResultBlock)completion;
-(void) selectEnityAtIndex:(NSInteger)index;

@end
