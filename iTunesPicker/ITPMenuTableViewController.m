//
//  IPTMenuTableViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPMenuTableViewController.h"
#import "ITPGraphic.h"

@interface ITPMenuTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) UIImage* overlayImage;
@end

@implementation ITPMenuTableViewController

- (instancetype)initWithMainImage:(UIImage *)image type:(tPAPMenuPickerType)type{
    if(self = [super initWithMainImage:image]) {
        _overlayImage = [image copy];
        _type = type;
    }
    
    return self;
}

-(void) dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.closeOffset = 0.0f;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setOverView:self.myOverView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UISwipeGestureRecognizer *swipeGestureRecognize = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(togglePanel)];
    swipeGestureRecognize.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRecognize];
    
//    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(togglePanel)];
//    tapGesture.numberOfTapsRequired = 1;
//    [self.overView addGestureRecognizer:tapGesture];
//    [self.mainImageView addGestureRecognizer:tapGesture];
    
    self.view.backgroundColor = [[ITPGraphic sharedInstance] commonContrastColor];
//    self.tableView.backgroundColor = [[ITPGraphic sharedInstance] commonContrastColor];
    
    self.tableView.rowHeight = menuItemHeight;
//    self.tableView.backgroundColor = [UIColor clearColor];
    
//    self.backgroundView = [[UIView alloc]initWithFrame:self.backgroundAreaDismissRect];
//    self.backgroundView.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.clipsToBounds = NO;
    
    // single tap gesture recognizer
//    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglePanel)];
//    tapGestureRecognize.numberOfTapsRequired = 1;
//    [tapGestureRecognize requireGestureRecognizerToFail:tapGestureRecognize];
//    [self.backgroundView addGestureRecognizer:tapGestureRecognize];
}
//
//-(void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

+(NSString*) getImageFromType:(tITunesEntityType)iTunesEntityType
{
    NSString* imageName;
    switch (iTunesEntityType) {
        case kITunesEntityTypeMusic:
            imageName = @"music";
            break;
        case kITunesEntityTypeMovie:
            imageName = @"cinema";
            break;
        case kITunesEntityTypeMusicVideo:
            imageName = @"videomusic";
            break;
        case kITunesEntityTypeEBook:
            imageName = @"books";
            break;
        case kITunesEntityTypeSoftware:
            imageName = @"apps";
            break;
        default:
            imageName = @"logo";
            break;
    }
    return imageName;
}

- (UIView *)myOverView {
    UIView *view = [[UIView alloc] initWithFrame:self.overView.bounds];
    
    //Add an example imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.center.x-50.0, view.center.y-60.0, 100.0, 100.0)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView setImage:_overlayImage];
    [imageView.layer setBorderColor:[[ITPGraphic sharedInstance] commonColor].CGColor];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setCornerRadius:imageView.frame.size.width/2.0];
    
    //Add an example label
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(view.center.x-120.0, view.center.y+50.0, 240.0, 50.0)];
    if(self.type == kPAPMenuPickerTypeRanking)
    {
        [lblTitle setText:NSLocalizedString(@"filter.title.chart", nil)];
    }
    else
    {
        [lblTitle setText:NSLocalizedString(@"filter.title.genre", nil)];
    }
    [lblTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[[ITPGraphic sharedInstance] commonContrastColor]];
    
    [view addSubview:imageView];
    [view addSubview:lblTitle];
    
    return view;
}

#pragma mark public

-(void) togglePanel
{
    [self togglePanelWithCompletionBlock:nil];
}

-(void) togglePanelWithCompletionBlock:(void (^)(BOOL isOpen))completion
{
//    if(!_isOpen)
//    {
////        self.view.hidden = NO;
//    }
    
    self.tableView.separatorColor = [[ITPGraphic sharedInstance] commonColor];
    
    [UIView animateWithDuration:0.8 animations:^{
        self.view.alpha = self.view.alpha==0.0?1.0:0.0;
//        if(self.isOpen){
////            self.view.frame = closeFrame;
////            [self.backgroundView removeFromSuperview];
//            self.view.alpha = 0.0;
//        }
//        else
//        {
////            self.view.frame = self.openFrame;
////            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
//            self.view.alpha = 1.0;
//        }
    } completion:^(BOOL finished) {
        
        _isOpen = self.view.alpha==1.0;
        
//        _isOpen = !self.isOpen;
//        if(!_isOpen)
//        {
////            self.view.hidden = YES;
//        }

        if(completion)
        {
            completion(self.isOpen);
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return self.items.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MenuItemCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = NSLocalizedString(self.items[indexPath.row],@"");
//    if(self.type == kPAPMenuPickerTypeGenre)
//    {
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//            cell.separatorInset = UIEdgeInsetsMake(0.0,0.0,0.0,15.0f);
//        }
//        cell.textLabel.textAlignment = NSTextAlignmentRight;
//    }

    cell.separatorInset = UIEdgeInsetsMake(0.0,15.0f,0.0,15.0f);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [[ITPGraphic sharedInstance] commonContrastColor];
    cell.contentView.backgroundColor = [[ITPGraphic sharedInstance] commonContrastColor];
//    cell.textLabel.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:16.0];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate)
    {
        [self.delegate valueSelectedAtIndex:indexPath.row forType:self.type refreshPickers:YES];
    }
//    [self togglePanel];
}

#pragma mark private

-(void)setOpenFrame:(CGRect)openFrame
{
    _openFrame = openFrame;
//    closeFrame = openFrame;
//    
//    switch (self.openDirection) {
//        case kPAPMenuOpenDirectionRight:
//            closeFrame.origin.x -= self.view.frame.size.width;
//            break;
//        case kPAPMenuOpenDirectionDown:
//            closeFrame.origin.y -= self.view.frame.size.height;
//            break;
//        case kPAPMenuOpenDirectionLeft:
//            closeFrame.origin.x += self.view.frame.size.width;
//            break;
//    }
//    
//    self.view.frame = closeFrame;
//    self.view.hidden = YES;
    self.view.alpha = 0;
    _isOpen = NO;
}

-(void) setOpenDirection:(kPAPMenuOpenDirection)openDirection
{
    _openDirection = openDirection;
    UISwipeGestureRecognizer *swipeGestureRecognize = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(togglePanel)];
    switch (openDirection) {
        case kPAPMenuOpenDirectionRight:
            swipeGestureRecognize.direction = UISwipeGestureRecognizerDirectionLeft;
            break;
        case kPAPMenuOpenDirectionDown:
            break;
            swipeGestureRecognize.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
        case kPAPMenuOpenDirectionLeft:
            swipeGestureRecognize.direction = UISwipeGestureRecognizerDirectionRight;
            break;
    }
    [self.view addGestureRecognizer:swipeGestureRecognize];
}

//-(void)setBackgroundAreaDismissRect:(CGRect)backgroundAreaDismissRect
//{
//    _backgroundAreaDismissRect = backgroundAreaDismissRect;
//    self.backgroundView.frame = backgroundAreaDismissRect;
//}

-(void)setItems:(NSArray *)items
{
    _items = items;
    [self.tableView reloadData];
}

//Eliminate Extra separators below UITableView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

/*
#pragma mark - UITableViewDelegate selection

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[[ITPGraphic sharedInstance] commonColor] ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor clearColor] ForCell:cell]; //normal color
    
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}
*/
@end

