//
//  ZNRentalItemVC.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNRentalItemVC.h"
#import "ZNEmptyView.h"
#import "ZNAPIManager.h"
#import "ZNRentalItemCell.h"
#import "ZNParentCategory.h"
#import "ZNRentalItemVC.h"
#import "ZNItemDetailsNC.h"
#import "ZNLocationManager.h"
#import "ZNAlertManager.h"

#define ITEMS_PAGE_SIZE 25
#define ITEM_CELL_IDENTIFIER @"ItemCell"
#define LOADING_CELL_IDENTIFIER @"LoadingCell"
#define CELL_HEIGHT 216
#define CELL_LINE_SPACE 8

@interface ZNRentalItemVC () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
- (IBAction)searchButtonClicked:(id)sender;

@property (strong, nonatomic) NSMutableArray *items;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *loadMoreFlags;

@end

@implementation ZNRentalItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:_subCategory.name];
    [self setNavigationBackButtonItem];
    
    _collectionView.backgroundView = [ZNEmptyView createView];
    _collectionView.backgroundView.hidden = YES;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_collectionView addSubview:_refreshControl];

    _page = 1;
    _loadMoreFlags = [[NSMutableDictionary alloc] init];
    _items = [[NSMutableArray alloc] init];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleRefresh:(id)sender
{
    _page = 1;
    [_loadMoreFlags removeAllObjects];
    
    [self loadData];
}
- (void)loadData
{
    if(_page == 1) [_items removeAllObjects];
    NSDictionary *selectedCity = [[ZNLocationManager sharedInstance] getSelectedCity];
    NSDictionary *location = selectedCity[@"location"];
    NSInteger radius = selectedCity[@"suggested"]&&[selectedCity[@"suggested"] boolValue] ? 200 : 15;
    NSDictionary *params = @{
                             @"category_id": _subCategory.id,
                             @"location": location,
                             @"radius": @(radius),
                             @"page": @(_page),
                             @"size": @(ITEMS_PAGE_SIZE)
                             };
    
    [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
    [[ZNAPIManager sharedInstance] getRentalItemsWithParams:params completion:^(id result, BOOL success) {
        [ZNAlertManager hideProgressBar];
        [_items addObjectsFromArray:result];
        
        _collectionView.backgroundView.hidden = _items.count;
        [_collectionView reloadData];
        
        if(_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
    }];
}
- (void)fetchMoreItems {
    NSLog(@"FETCHING MORE ITEMS ******************");
    
    _page ++;

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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    ZNRentalItem *item = [_items objectAtIndex:indexPath.row];
    
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

- (IBAction)searchButtonClicked:(id)sender
{
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSearchItemNC"];
    [self presentViewController:nc animated:YES completion:nil];
}
@end
