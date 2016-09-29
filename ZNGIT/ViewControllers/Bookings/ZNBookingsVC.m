//
//  ZNBookingsVC.m
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNBookingsVC.h"
#import "ZNEmptyView.h"
#import "ZNAPIManager.h"
#import "ZNBookItemCell.h"
#import "ZNOrderDetailsViewNC.h"
#import "ZNAlertManager.h"
#import "AppDelegate.h"

#define TITLE @"MY BOOKINGS"

#define ITEMS_PAGE_SIZE 5
#define ITEM_CELL_IDENTIFIER @"BookItemCell"
#define LOADING_CELL_IDENTIFIER @"LoadingCell"
#define ROW_HEIGHT 140


@interface ZNBookingsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *loadMoreFlags;

@end

@implementation ZNBookingsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:TITLE];
    
    
    
    
    
    ZNEmptyView *emptyView = [ZNEmptyView createView];
    emptyView.logoImage = [UIImage imageNamed:@"empty_logo1.png"];
    emptyView.message = @"You haven’t booked any rental items yet. They will appear here after you place an order.";
    _tableView.backgroundView = emptyView;
    _tableView.backgroundView.hidden = YES;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LOADING_CELL_IDENTIFIER];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
    
    _loadMoreFlags = [[NSMutableDictionary alloc] init];
    _items = [NSMutableArray new];
    _page = 1;
    
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForNotificationBookingsUpdated:) name:ZN_NOTIFICATION_BOOKINGS_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForNotificationCurrentUserChanged:) name:ZN_NOTIFICATION_CURRENT_USER_CHANGED object:nil];
}

- (void)handlerForNotificationBookingsUpdated:(NSNotification*)notification
{
    _page = 1;
    
    [_loadMoreFlags removeAllObjects];
    
    [self loadData];
}
- (void)handlerForNotificationCurrentUserChanged:(NSNotification*)notification
{
    [self loadData];
}


- (void)handleRefresh:(id)sender
{
    _page = 1;
    
    [_loadMoreFlags removeAllObjects];
    
    [self loadData];
}
- (void)fetchMoreItems {
    NSLog(@"FETCHING MORE ITEMS ******************");
    
    _page ++;

    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    if(_page == 1) [_items removeAllObjects];
    
    [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
    NSDictionary *params = @{
                             @"page": @(_page),
                             @"size": @(ITEMS_PAGE_SIZE)
                             };
    [[ZNAPIManager sharedInstance] getMyBookingItems:params completion:^(id result, BOOL success) {
        [ZNAlertManager hideProgressBar];
        if(success && result && ((NSArray*)result).count)
        {
            [_items addObjectsFromArray:result];
        }
        
        _tableView.backgroundView.hidden = _items.count;
        [_tableView reloadData];
        
        if(_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
    }];
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZNBookItem *item = _items[indexPath.row];
    
    ZNOrderDetailsViewNC *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNOrderDetailsViewNC"];
    
    nc.item = item;
    
    [self presentViewController:nc animated:YES completion:nil];
}
- (UITableViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    ZNBookItemCell *cell = (ZNBookItemCell*) [_tableView dequeueReusableCellWithIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Update the custom cell with some text
    ZNBookItem *item = [_items objectAtIndex:indexPath.row];
    
    [cell bindModel:item];
    
    
    return cell;
}

- (UITableViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    return cell;
}

@end
