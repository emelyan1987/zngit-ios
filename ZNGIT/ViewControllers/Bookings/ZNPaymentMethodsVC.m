//
//  ZNPaymentMethodsVC.m
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNPaymentMethodsVC.h"
#import "ZNAddCreditCardVC.h"
#import "ZNSettingsManager.h"
#import "ZNPaymentMethodCell.h"

#define TITLE @"PAYMENT METHODS"

@interface ZNPaymentMethodsVC () <ZNAddCreditCardVCDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRecognizer;
@end

@implementation ZNPaymentMethodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBackButtonItem];
    [self setNavigationBarTitle:TITLE];
    
    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self                                                                            action:@selector(handleSwipeGesture:)];
    [_swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_tableView addGestureRecognizer:_swipeRecognizer];
    
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    _items = [NSMutableArray new];
    
    NSArray *cards = [[ZNSettingsManager sharedInstance] getCreditCards];
    if(cards!=nil && cards.count) [_items addObjectsFromArray:cards];
    
    [_tableView reloadData];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    
    NSDictionary *item = _items[indexPath.row];
    [[ZNSettingsManager sharedInstance] removeCreditCard:item[@"number"]];
    [_items removeObject:item];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView endUpdates];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;
    if([segueIdentifier isEqualToString:@"AddCreditCardSegue"])
    {
        ZNAddCreditCardVC *vc = segue.destinationViewController;
        
        vc.delegate = self;
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZNPaymentMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentMethodCell"];
    
    NSDictionary *data = _items[indexPath.row];
    [cell bindData:data];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = _items[indexPath.row];
    
    [[ZNSettingsManager sharedInstance] setPrimaryCreditCard:item];
    [_tableView reloadData];
}
#pragma mark ZNAddCreditCardVCDelegate implementation

- (void)didAddCreditCardData
{
    [self loadData];
}

@end
