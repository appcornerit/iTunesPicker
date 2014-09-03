//
//  IPTMenuTableViewController.h
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "MGSpotyViewController.h"

typedef enum {
    kPAPMenuPickerTypeRanking = 0,
    kPAPMenuPickerTypeGenre,
} tPAPMenuPickerType;

typedef enum {
    kPAPMenuOpenDirectionRight= 0,
    kPAPMenuOpenDirectionLeft,
    kPAPMenuOpenDirectionDown
} kPAPMenuOpenDirection;

static CGFloat menuItemHeight = 44.0f;

@protocol ITPMenuTableViewDelegate <NSObject>

-(void)valueSelectedAtIndex:(NSInteger)index forType:(tPAPMenuPickerType)type refreshPickers:(BOOL)refresh;

@end

@interface ITPMenuTableViewController : MGSpotyViewController
{
    CGRect closeFrame;
}

//@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) IBOutlet UIView *backgroundView;

//@property (assign, nonatomic) CGRect backgroundAreaDismissRect;
@property (assign, nonatomic) CGFloat closeOffset;
@property (assign, nonatomic) tPAPMenuPickerType type;
@property (assign, nonatomic) kPAPMenuOpenDirection openDirection;
@property (strong, nonatomic) NSArray* items;
@property (assign, nonatomic) CGRect openFrame;
@property (weak, nonatomic) id<ITPMenuTableViewDelegate> delegate;
@property (readonly) BOOL isOpen;

- (instancetype)initWithMainImage:(UIImage *)image type:(tPAPMenuPickerType)type;
-(void) togglePanel;
-(void) togglePanelWithCompletionBlock:(void (^)(BOOL isOpen))completion;
+(NSString*) getImageFromType:(tITunesEntityType)iTunesEntityType;

@end
