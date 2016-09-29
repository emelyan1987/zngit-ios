//
//  ZNSearchCityVC.m
//  ZNGIT
//
//  Created by LionStar on 3/11/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSearchCityVC.h"
#import "ZNLocationManager.h"
#import "ZNCityCell.h"
#import "ZNAPIManager.h"
#import "ZNEmptyView1.h"

#define ROW_HEIGHT 53

@interface ZNSearchCityVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) NSMutableArray *items;


- (IBAction)closeButtonClicked:(id)sender;

@property NSTimer *timer;
@end

@implementation ZNSearchCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateTitle];
    
    _tableView.backgroundView = [ZNEmptyView1 createView];
    _tableView.backgroundView.hidden = NO;
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    //[self.view addGestureRecognizer:_tapRecognizer];
    
    [self loadData:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:ZN_NOTIFICATION_SELECTED_CITY_UPDATED object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapAction
{
    [self.view endEditing:YES];
}
- (void)loadData:(NSString*)keyword
{
    _items = [NSMutableArray new];
    
    if(keyword==nil || keyword.length==0)
    {
        NSArray *suggestedCities = [[ZNLocationManager sharedInstance] getSuggestedCities];
        
        if(suggestedCities && suggestedCities.count)
        {
            [_items addObjectsFromArray:suggestedCities];
            _tableView.backgroundView.hidden = YES;
        }
        else
        {
            _tableView.backgroundView.hidden = NO;
        }
        
        [_tableView reloadData];

    }    
    else
    {
        [[ZNAPIManager sharedInstance] getCitiesFromGoogleWithKeyword:keyword completion:^(id result, BOOL success) {
            if(success)
            {
                NSArray *cities = result;
                
                for(NSString *cityName in cities)
                {
                    NSDictionary *item = @{@"name": cityName, @"location":@"0.0,0.0"};
                    [_items addObject:item];
                }
                
                
                [_tableView reloadData];
                
                if(_items.count)
                {
                    _tableView.backgroundView.hidden = YES;
                }
                else
                {
                    _tableView.backgroundView.hidden = NO;
                }
            }
        }];
    }
}
- (void)updateTitle
{
    NSDictionary *city = [[ZNLocationManager sharedInstance] getSelectedCity];
    
    [self setNavigationBarTitle:city[@"name"] withIcon:[UIImage imageNamed:@"arrow_up.png"] iconPosition:ZNNavTitleIconRight];
}

- (void)reloadData
{
    [_tableView reloadData];
}
- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZNCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    
    NSDictionary *item = _items[indexPath.row];
    
    NSDictionary *selectedCity = [[ZNLocationManager sharedInstance] getSelectedCity];
    
    BOOL selected = [item[@"name"] isEqualToString:selectedCity[@"name"]];
    [cell bindData:item selected:selected];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = _items[indexPath.row];
    
    [[ZNLocationManager sharedInstance] setSelectedCity:item];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _items = [NSMutableArray new];
    [_tableView reloadData];
    
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
    [self loadData:_searchTextField.text];
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
