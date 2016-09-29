//
//  ZNSubCategoryVC.m
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSubCategoryVC.h"

#import "ZNEmptyView.h"
#import "ZNAPIManager.h"
#import "ZNSubCategoryCell.h"
#import "ZNParentCategory.h"
#import "ZNSubCategory.h"
#import "ZNRentalItemVC.h"
#import "AppDelegate.h"
#import "ZNAlertManager.h"

#define ITEM_CELL_IDENTIFIER @"CategoryCell"
#define CELL_HEIGHT 216
#define CELL_LINE_SPACE 8

@interface ZNSubCategoryVC () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)searchButtonClicked:(id)sender;

@property (strong, nonatomic) NSArray *items;
@end

@implementation ZNSubCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBackButtonItem];
    
    _collectionView.backgroundView = [ZNEmptyView createView];
    _collectionView.backgroundView.hidden = YES;
    
    [self updateCategories];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCategories) name:ZN_NOTIFICATION_CATEGORIES_UPDATED object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCategories
{
    _items = [NSArray new];
    NSArray *parentCategories = [AppDelegate sharedInstance].categories;
    
    for(ZNParentCategory *category in parentCategories)
    {
        if([category.id isEqualToNumber:_parentCategoryId])
        {
            [self setNavigationBarTitle:category.name];
            
            _items = category.subCategories;
            
            break;
        }
    }
    _collectionView.backgroundView.hidden = _items.count;
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
    ZNSubCategoryCell *cell = (ZNSubCategoryCell*) [_collectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Update the custom cell with some text
    ZNSubCategory *item = [_items objectAtIndex:indexPath.row];
    
    [cell bindModel:item];
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [[_collectionView indexPathsForSelectedItems] firstObject];
    
    // Set the thing on the view controller we're about to show
    if (selectedIndexPath != nil) {
        ZNRentalItemVC *vc = segue.destinationViewController;
        ZNSubCategory *item = _items[selectedIndexPath.row];
        
        vc.subCategory = item;
    }
}

- (IBAction)searchButtonClicked:(id)sender
{
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSearchItemNC"];
    [self presentViewController:nc animated:YES completion:nil];
}
@end
