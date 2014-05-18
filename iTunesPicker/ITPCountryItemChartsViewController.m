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


#import "ITPCountryItemChartsViewController.h"

static NSString *CellIdentifier = @"CountryCell";
@interface ITPCountryItemChartsViewController ()<UISearchDisplayDelegate, UISearchBarDelegate>
@property (nonatomic) UISearchDisplayController *searchController;
@end

@implementation ITPCountryItemChartsViewController{
    NSMutableArray *_filteredList;
    NSArray *_sections;
    NSMutableSet* internalSelectedCountries;
    
    NSArray* allCountries;
    NSSet* selectedCountries;
    NSString* userCountry;
    NSArray* indexCharts;
    
    BOOL chartMode;
    BOOL multiSelect;
    BOOL isModal;
    ACKITunesEntity* item;
}


- (id)initWithStyle:(UITableViewStyle)style allCountries:(NSArray*)aCountries selectedCountries:(NSSet*)sCountries userCountry:(NSString*)uCountry multiSelect:(BOOL)mSelect isModal:(BOOL)modal
{
    if (self = [super initWithStyle:style]) {
        allCountries = aCountries;
        selectedCountries = sCountries;
        internalSelectedCountries = [[NSMutableSet alloc]initWithSet:selectedCountries];
        userCountry = uCountry;
        chartMode = NO;
        multiSelect = mSelect;
        isModal = modal;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style allCountries:(NSArray*)aCountries indexCharts:(NSArray*)iCharts item:(ACKITunesEntity*)i
{
    if (self = [super initWithStyle:style]) {
        allCountries = aCountries;
        indexCharts = iCharts;
        item = i;
        chartMode = YES;
        self.tableView.allowsSelection = NO;
        isModal = NO;
    }
    return self;
}

- (void)createSearchBar {
    if (self.tableView && !self.tableView.tableHeaderView) {
        UISearchBar * theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,40)]; // frame has no effect.
        theSearchBar.delegate = self;
        
        self.tableView.tableHeaderView = theSearchBar;
        
        UISearchDisplayController *searchCon = [[UISearchDisplayController alloc]
                                                initWithSearchBar:theSearchBar
                                                contentsController:self ];
        self.searchController = searchCon;
        _searchController.delegate = self;
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsDelegate = self;
        
        [theSearchBar becomeFirstResponder];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSearchBar];
    
    if(!internalSelectedCountries)
    {
        internalSelectedCountries = [[NSMutableSet alloc]init];
    }
    
    if(multiSelect)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(doneAction:)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
    else if(isModal)
    {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                       target:self
                                       action:@selector(cancelAction:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    if(allCountries)
    {
        countryCodes = allCountries;
    }
    
    
    NSMutableArray *countriesUnsorted = [[NSMutableArray alloc] init];
    _filteredList = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *countryCode in countryCodes) {
        
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        
        if(chartMode)
        {
            NSInteger position = [((NSNumber*)indexCharts[i])integerValue];
            if(position != NSNotFound)
            {
                displayNameString = [NSString stringWithFormat:@"%@ - %d",displayNameString,position+1];
                NSDictionary *cd = @{@"name": displayNameString, @"code":[countryCode uppercaseString]};
                [countriesUnsorted addObject:cd];
            }
        }
        else
        {
            NSDictionary *cd = @{@"name": displayNameString, @"code":[countryCode uppercaseString]};
            [countriesUnsorted addObject:cd];
        }
        i++;
    }
    _sections = [self partitionObjects:countriesUnsorted collationStringSelector:@selector(self)];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(preferredContentSizeChanged:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
}
- (void)preferredContentSizeChanged:(NSNotification *)notification {
    [self.tableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

#pragma mark - Table view data source
-(NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionCount = [[collation sectionTitles] count];
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    for (int i = 0; i < sectionCount; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    for (id object in array) {
        NSInteger index = [collation sectionForObject:object[@"name"] collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    for (NSMutableArray *section in unsortedSections) {
        NSArray *sortedArray = [section sortedArrayUsingDescriptors:sortDescriptors];
        [sections addObject:sortedArray];
    }
    
    return sections;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [UILocalizedIndexedCollation.currentCollation sectionIndexTitles];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
    //we use sectionTitles and not sections
    return [[UILocalizedIndexedCollation.currentCollation sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [_filteredList count];
    }
    return [_sections[section] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    BOOL showSection = [[_sections objectAtIndex:section] count] != 0;
    //only show the section title if there are rows in the section
    return (showSection) ? [[UILocalizedIndexedCollation.currentCollation sectionTitles] objectAtIndex:section] : nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *cd = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        cd = _filteredList[indexPath.row];
        
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:cd[@"name"] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.785 alpha:1.000], NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
        [attributedTitle addAttribute:NSForegroundColorAttributeName
                                value:[UIColor blackColor]
                                range:[attributedTitle.string.lowercaseString rangeOfString:_searchController.searchBar.text.lowercaseString]];
        
        cell.textLabel.attributedText = attributedTitle;
    }
	else
	{
        cd = _sections[indexPath.section][indexPath.row];
        
        cell.textLabel.text = cd[@"name"];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    
    cell.imageView.image = [UIImage imageNamed:cd[@"code"]];
    
    if(!chartMode)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if([internalSelectedCountries containsObject:cd[@"code"]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *cd = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        cd = _filteredList[indexPath.row];
    }
    else{
        cd = _sections[indexPath.section][indexPath.row];
    }
    
    if(!chartMode)
    {
        if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
            
#if !TARGET_IPHONE_SIMULATOR
            if(multiSelect && self.countriesSelectionLimit == internalSelectedCountries.count)
            {
                return;
            }
#endif
            thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [internalSelectedCountries addObject:cd[@"code"]];
        }else{
            thisCell.accessoryType = UITableViewCellAccessoryNone;
            [internalSelectedCountries removeObject:cd[@"code"]];
        }
    }
    
    if(!multiSelect)
    {
        if (self.completionBlock) {
            self.completionBlock(@[cd[@"code"]]);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[_filteredList removeAllObjects];
    
    for (NSArray *section in _sections) {
        for (NSDictionary *dict in section)
        {
            NSComparisonResult result = [dict[@"name"] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [_filteredList addObject:dict];
            }
        }
    }
}
#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][searchOption]];
    
    return YES;
}
#pragma mark - searchBar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchController.searchBar isFirstResponder] && [touch view] != self.searchController.searchBar)
    {
        [self.searchController.searchBar resignFirstResponder];
        [self.tableView setUserInteractionEnabled:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)doneAction:(id)sender {
    if(!chartMode)
    {
        if (self.completionBlock) {
            self.completionBlock([internalSelectedCountries allObjects]);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
