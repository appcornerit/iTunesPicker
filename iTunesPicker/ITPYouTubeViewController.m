//
//  ITPYouTubeViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 16/08/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPYouTubeViewController.h"
#import "ITPAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ITPYouTubeViewController ()

@end

@implementation ITPYouTubeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"ITPYouTubeVideoCell" bundle:nil] forCellReuseIdentifier:@"videoCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentOffset = CGPointMake(0, -40.0);
    [self scrollViewDidScroll:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setVideosArray:(NSArray *)videosArray
{
    _videosArray = videosArray;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videosArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"videoCell";
    ITPYouTubeVideoCell *cell = (ITPYouTubeVideoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell != nil) {
        NSDictionary *dic = [self.videosArray objectAtIndex:indexPath.row];
        [cell setupWithDictionary:dic];
    }
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.videosArray objectAtIndex:indexPath.row];
    NSString *videoId = dic[@"id"];
    [self presentVideoPlayer:[[ACKYouTube sharedInstance]playerVideoWithId:videoId]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableView visibleCells];
    
    for (ITPYouTubeVideoCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
    }
}

-(void)presentVideoPlayer:(MPMoviePlayerViewController*)moviePlayerView
{
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:moviePlayerView
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerView.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayerView.moviePlayer];
    ((ITPAppDelegate*)[UIApplication sharedApplication].delegate).allowOrientation = YES;
    
    [self presentMoviePlayerViewControllerAnimated:moviePlayerView];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        ((ITPAppDelegate*)[UIApplication sharedApplication].delegate).allowOrientation = NO;
        //
        //        // Dismiss the view controller
        [self dismissMoviePlayerViewControllerAnimated];
    }
}


#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = NSLocalizedString(@"error_nodata", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"logo"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !loading;
}

@end
