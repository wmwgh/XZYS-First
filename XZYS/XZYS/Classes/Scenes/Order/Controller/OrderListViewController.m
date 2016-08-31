//
//  OrderListViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/27.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "OrderListViewController.h"
#import "XZYS_Other.h"
#import "AllOrderListCell.h"
#import "DaiOrderListCell.h"
static NSString *headerID = @"cityHeaderSectionID";
static NSString *footerID = @"cityFooterSectionID";
@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic , strong) NSArray *allDataArray;

@end

@implementation OrderListViewController
- (NSArray *)allDataArray {
    if (_allDataArray) {
        _allDataArray = [NSArray array];
    }
    return _allDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单管理";
    [self setButton];
    [self setNav];
    self.allDataArray = @[@"asd", @"asdf"];
}

- (void)setNav {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 158) style:UITableViewStyleGrouped];
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([AllOrderListCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    [self.view addSubview:self.mainTab];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    titleLabel.backgroundColor = [UIColor orangeColor];
    [headerView addSubview:titleLabel];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerID];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    footView.backgroundColor = [UIColor cyanColor];
    [footerView addSubview:footView];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainTab deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)allOrder:(id)sender {
    [self.allButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.lineView.frame = CGRectMake(10, 105, SCREEN_WIDTH / 5 - 20, 3);
}
- (IBAction)daiPay:(id)sender {
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
}
- (IBAction)yiPay:(id)sender {
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 3 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
}
- (IBAction)daiReceive:(id)sender {
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 2 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
}
- (IBAction)yiComplate:(id)sender {
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 4 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
}

// 按钮
- (void)setButton {
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = XZYSBlueColor;
    [self.view addSubview:self.lineView];
    
    if (_aaaa == 0) {
        [self.allButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.lineView.frame = CGRectMake(10, 105, SCREEN_WIDTH / 5 - 20, 3);
    } else if (_aaaa == 1) {
        [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    } else if (_aaaa == 2) {
        [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 2 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    } else if (_aaaa == 3) {
        [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.yiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 3 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    } else if (_aaaa == 4) {
        [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.complateButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 4 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
