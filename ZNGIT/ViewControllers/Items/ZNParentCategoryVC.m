//
//  ZNParentCategoryVC.m
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNParentCategoryVC.h"
#import "ZNSubCategoryVC.h"
#import "OBGradientView.h"
#import "ZNEmptyView.h"
#import "ZNAPIManager.h"
#import "ZNParentCategoryCell.h"
#import "ZNParentCategory.h"
#import "ZNLocationManager.h"
#import "AppDelegate.h"

#define ITEM_CELL_IDENTIFIER @"CategoryCell"
#define CELL_HEIGHT 216
#define CELL_LINE_SPACE 8

@interface ZNParentCategoryVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet OBGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
- (IBAction)searchButtonClicked:(id)sender;


@property (strong, nonatomic) NSArray *items;
@end

@implementation ZNParentCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor clearColor], [UIColor whiteColor], nil];
    _gradientView.colors = colors;
    
    _collectionView.layer.cornerRadius = 5.0f;
    _collectionView.backgroundView = [ZNEmptyView createView];
    _collectionView.backgroundView.hidden = NO;
    
    [self updateCity];
    [self updateCategories];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCity) name:ZN_NOTIFICATION_SELECTED_CITY_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationCategoriesUpdated:) name:ZN_NOTIFICATION_CATEGORIES_UPDATED object:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleNotificationCategoriesUpdated:(NSNotification*)notification
{
    if([self updatedCategories])
    {
        [self updateCategories];
    }
}

- (BOOL)updatedCategories
{
    NSArray *categories = [AppDelegate sharedInstance].categories;
    if(_items.count != categories.count) return YES;
    
    for(ZNParentCategory *category in categories)
    {
        if([self updatedCategory:category]) return YES;
    }
    return NO;
}

- (BOOL)updatedCategory:(ZNParentCategory*)category
{
    BOOL bUpdated = YES;
    for(ZNParentCategory *item in _items)
    {
        if([item.id isEqualToNumber:category.id])
        {
            bUpdated = NO;
            
            if(![item.updatedTime isEqualToNumber:category.updatedTime])
                bUpdated = YES;
        }
    }
    return bUpdated;
}

- (void)updateCity
{
    NSDictionary *city = [[ZNLocationManager sharedInstance] getSelectedCity];
    NSString *cityName = city[@"name"];
    
    [self setNavigationBarTitle:cityName withIcon:[UIImage imageNamed:@"arrow_down.png"] iconPosition:ZNNavTitleIconRight];
    
    UIView *titleView = self.navigationItem.titleView;
    UIButton *btnTitle = [[UIButton alloc] initWithFrame:titleView.frame];
    
    [btnTitle addTarget:self action:@selector(btnTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnTitle.userInteractionEnabled=YES;
    [titleView addSubview:btnTitle];
}

- (void)btnTitleClicked:(id)sender
{
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSearchCityNC"];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)updateCategories
{
    _items = [AppDelegate sharedInstance].categories;
    
    _collectionView.backgroundView.hidden = _items.count;
    
    _collectionViewHeightConstraint.constant = (CELL_HEIGHT+CELL_LINE_SPACE) * _items.count;
    
    [self.view layoutIfNeeded];
    [_collectionView reloadData];
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
    
    return [self itemCellForIndexPath:indexPath];
}

- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    ZNParentCategoryCell *cell = (ZNParentCategoryCell*) [_collectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Update the custom cell with some text
    ZNParentCategory *item = [_items objectAtIndex:indexPath.row];
    
    [cell bindModel:item];
    
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [[_collectionView indexPathsForSelectedItems] firstObject];
    
    // Set the thing on the view controller we're about to show
    if (selectedIndexPath != nil) {
        ZNSubCategoryVC *vc = segue.destinationViewController;
        ZNParentCategory *item = _items[selectedIndexPath.row];
        
        vc.parentCategoryId = item.id;
    }
}
- (IBAction)searchButtonClicked:(id)sender
{
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSearchItemNC"];
    [self presentViewController:nc animated:YES completion:nil];
}


@end
