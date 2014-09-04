//
//  ITPSideLeftMenuViewController.m
//  iTunesPicker
//
//  Created by Denis Berton on 10/05/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPSideLeftMenuViewController.h"
#import "ITPGraphic.h"
#import "ITPMorphingTableViewCell.h"

@interface ITPSideLeftMenuViewController ()
{
    BOOL animating;
}
@end

@implementation ITPSideLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view insertSubview:self.logoView belowSubview:self.tableView];
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.logoView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:0.0],
                                [NSLayoutConstraint constraintWithItem:self.logoView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0.0],
                                [NSLayoutConstraint constraintWithItem:self.logoView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0.0],
                                [NSLayoutConstraint constraintWithItem:self.logoView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0
                                                              constant:300.0],
                                [NSLayoutConstraint constraintWithItem:self.logoView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0
                                                              constant:370.0],
                                ]];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"ITPMorphingTableViewCell" bundle:nil] forCellReuseIdentifier:@"ITPMorphingTableViewCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingChange:) name:NOTIFICATION_LOADING_CHANGE object:nil];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadingChange:(NSNotification*)notification
{
    _pickerLoading = [notification.userInfo[ @"loading"]boolValue];
    [self.tableView reloadData];
}

#pragma mark - MSLogoViewController

- (UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _logoView.translatesAutoresizingMaskIntoConstraints = NO;
        _logoView.contentMode = UIViewContentModeCenter;
    }
    return _logoView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section) {
        case 0:
            return 2;
        default:
            return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [NSLocalizedString(@"menu.section.filters", nil) uppercaseString];
        default:
            return [NSLocalizedString(@"menu.section.views", nil) uppercaseString];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.font = [UIFont systemFontOfSize:20];
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
        tableViewHeaderFooterView.backgroundView.backgroundColor = [UIColor clearColor]; //[[ITPGraphic sharedInstance] commonColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ITPMorphingTableViewCell";
    
    ITPMorphingTableViewCell *cell = (ITPMorphingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[ITPMorphingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.morphLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.morphLabel.textAlignment = NSTextAlignmentLeft;
    cell.imageView.image = nil;

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.morphLabel.text = [self.delegate getSelectedFilterLabel:kITPMenuFilterPanelRanking];
                    break;
                case 1:
                    cell.morphLabel.text = [self.delegate getSelectedFilterLabel:kITPMenuFilterPanelGenre];
                    break;
            }
            break;
        case 1:
            if(_pickerLoading)
            {
                cell.morphLabel.textColor = [UIColor grayColor];
            }
            switch (indexPath.row) {
                case 0:
                    cell.morphLabel.text = NSLocalizedString(@"menu.discoverview", nil);
                    break;
                case 1:
                    cell.morphLabel.text = NSLocalizedString(@"menu.globalrankingview", nil);
                    break;
            }
            break;            
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self.delegate toggleMenuPanel:kITPMenuFilterPanelRanking];
                    break;
                case 1:
                    [self.delegate toggleMenuPanel:kITPMenuFilterPanelGenre];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.delegate openDiscoverView];
                    break;
                case 1:
                    [self.delegate openGlobalRankingView];
                    break;
            }
            break;
    }
}

//Eliminate Extra separators below UITableView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


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

@end
