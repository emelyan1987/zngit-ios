//
//  ZNSearchItemVC.m
//  ZNGIT
//
//  Created by LionStar on 3/11/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSearchItemVC.h"

#import "ZNEmptyView.h"
#import "ZNAPIManager.h"
#import "ZNRentalItemCell.h"
#import "ZNRentalItem.h"
#import "ZNRentalItemVC.h"
#import "ZNItemDetailsNC.h"
#import "ZNLocationManager.h"
#import "ZNAlertManager.h"


#define ITEMS_PAGE_SIZE 5
#define ITEM_CELL_IDENTIFIER @"ItemCell"
#define LOADING_CELL_IDENTIFIER @"LoadingCell"
#define CELL_HEIGHT 216
#define CELL_LINE_SPACE 8

@interface ZNSearchItemVC () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)cancelButtonClicked:(id)sender;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *loadMoreFlags;
@end

@implementation ZNSearchItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    ZNEmptyView *emptyView = [ZNEmptyView createView];
    emptyView.message = @"Enter an item name to search";
    _collectionView.backgroundView = emptyView;
    _collectionView.backgroundView.hidden = NO;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    
    _loadMoreFlags = [[NSMutableDictionary alloc] init];
    _items = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    
    CGFloat navWidth = self.navigationController.navigationBar.frame.size.width;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Light" size:14.0f];
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, navWidth-150, navHeight)];
    [_searchTextField setFont:font];
    _searchTextField.textColor = UIColorFromRGB(0x818181);
    _searchTextField.placeholder = @"Search for any rental item...";
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.delegate = self;
    
    CGRect headerFrame = CGRectMake(0, 0, navWidth-150, navHeight);
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    [headerView addSubview:_searchTextField];
    
    self.navigationItem.titleView = headerView;
    
    _page = 1;
}

- (void)loadData
{    
    if(_page == 1) [_items removeAllObjects];
    
    
    NSString *keyword = _searchTextField.text;
    if(keyword==nil || keyword.length==0)
    {
        _collectionView.backgroundView.hidden = NO;
        [_collectionView reloadData];
        return;
    }
    
    NSDictionary *selectedCity = [[ZNLocationManager sharedInstance] getSelectedCity];
    NSDictionary *location = selectedCity[@"location"];
    NSInteger radius = selectedCity[@"suggested"]&&[selectedCity[@"suggested"] boolValue] ? 200 : 15;
    NSDictionary *params = @{
                             @"name": keyword,
                             @"location": location,
                             @"radius": @(radius),
                             @"page": @(_page),
                             @"size": @(ITEMS_PAGE_SIZE)
                             };
    
    [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
    [[ZNAPIManager sharedInstance] getRentalItemsWithParams:params completion:^(id result, BOOL success) {
        [ZNAlertManager hideProgressBar];
        if(success && result && ((NSArray*)result).count)
        {
            [_items addObjectsFromArray:result];
        }
        
        _collectionView.backgroundView.hidden = _items.count;
        [_collectionView reloadData];
    }];
}

- (void)fetchMoreItems {
    NSLog(@"FETCHING MORE ITEMS ******************");
    
    _page++;
    [self loadData];
}
#pragma mark UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_collectionView.frame.size.width, CELL_HEIGHT);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CELL_LINE_SPACE;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemIndex = indexPath.item;
    
    if(itemIndex == _items.count-1)
    {
        BOOL loadMoreFlag = [_loadMoreFlags objectForKey:@(itemIndex)];
        if(!loadMoreFlag)
        {
            [self fetchMoreItems];
            [_loadMoreFlags setObject:[NSNumber numberWithBool:YES] forKey:@(itemIndex)];
        }
    }
    return [self itemCellForIndexPath:indexPath];
}

- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    ZNRentalItemCell *cell = (ZNRentalItemCell*) [_collectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Update the custom cell with some text
    NSInteger index = indexPath.row;
    ZNRentalItem *item = [_items objectAtIndex:index];
    
    [cell bindModel:item];
    
    
    return cell;
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [[_collectionView indexPathsForSelectedItems] firstObject];
    
    // Set the thing on the view controller we're about to show
    if (selectedIndexPath != nil) {
        ZNItemDetailsNC *nc = segue.destinationViewController;
        ZNRentalItem *item = _items[selectedIndexPath.row];
        
        nc.item = item;
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                              target: self
                                            selector: @selector(timeToSearchForStuff:)
                                            userInfo: nil
                                             repeats: NO];
    
    return YES;
}

-(void) timeToSearchForStuff:(NSTimer*)theTimer
{
    _page = 1;
    [_loadMoreFlags removeAllObjects];
    [self loadData];
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
