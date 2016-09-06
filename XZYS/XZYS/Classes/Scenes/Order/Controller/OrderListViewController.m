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
@property (nonatomic , strong) UILabel *nomalLabel;
@property (nonatomic , strong) UIImageView *dpImage;
@property (nonatomic , assign) NSInteger orderType;
@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , strong) NSArray *cellAllay;

@end

@implementation OrderListViewController
- (NSArray *)allDataArray {
    if (_allDataArray) {
        _allDataArray = [NSArray array];
    }
    return _allDataArray;
}
- (NSArray *)titleArray {
    if (_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}
- (NSArray *)cellAllay {
    if (_cellAllay) {
        _cellAllay = [NSArray array];
    }
    return _cellAllay;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单管理";
    self.titleArray = @[@"1235567890", @"0987d3465432", @"7689876545678"];
    NSLog(@"%@", self.titleArray);
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}
#pragma 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
#pragma maik ------ 代付款订单
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    UIImageView *dpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 25, 25)];
    dpImage.image = [UIImage imageNamed:@"dp_sd"];
    [backView addSubview:dpImage];
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(45, 0, SCREEN_WIDTH - 140, 40);
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 145, 40)];
    titLabel.font = [UIFont systemFontOfSize:14];
    [backView bringSubviewToFront:titLabel];
    [backView addSubview:titLabel];
    [titleButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleBT) forControlEvents:UIControlEventTouchUpInside];
    titleButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [backView addSubview:titleButton];
    UIImageView *jianimage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleButton.frame), 12, 15, 17)];
    jianimage.image = [UIImage imageNamed:@"dp_ht"];
    [backView addSubview:jianimage];
    self.nomalLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 58, 7, 50, 30)];
    self.nomalLabel.textColor = XZYSPinkColor;
    self.nomalLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:self.nomalLabel];
    
    if (_orderType == 1) {
        titLabel.text = @"11111111111111111111";
        self.nomalLabel.text = @"代付款";
        return headerView;
#pragma maik ------ 待收货订单
    } else if (_orderType == 2) {
        titLabel.text = @"222222222222222222222";
        self.nomalLabel.text = @"待收货";
        return headerView;
#pragma maik ------ 已付款订单
    } else if (_orderType == 3) {
        titLabel.text = @"3333333333333333333";
        self.nomalLabel.text = @"已付款";
        return headerView;
#pragma maik ------ 已完成订单
    } else if (_orderType == 4) {
        titLabel.text = @"444444444444444444";
        self.nomalLabel.text = @"已完成";
        return headerView;
    } else {
        NSLog(@"all");
    }
    
    
    return nil;
}
- (void)titleBT {
    NSLog(@"title");
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_orderType == 1) {
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerID];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        footView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:footView];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 30)];
        priceLabel.font = [UIFont systemFontOfSize:11];
        priceLabel.text = @"订单金额:";
        [footView addSubview:priceLabel];
        UILabel *priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 60, 30)];
        priceLabel1.textColor = XZYSPinkColor;
        priceLabel1.font = [UIFont systemFontOfSize:11];
        priceLabel1.text = @"$1234567";
        [footView addSubview:priceLabel1];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
        [deleteButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [footView addSubview:deleteButton];
        
        UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6.5 - 20, 4, SCREEN_WIDTH / 6.5, 22);
        [orderButton setTitle:@"订单详情" forState:UIControlStateNormal];
        orderButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [orderButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
        [orderButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [footView addSubview:orderButton];
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 3 / 6.5 - 30, 4, SCREEN_WIDTH / 6.5, 22);
        [payButton setTitle:@"去支付" forState:UIControlStateNormal];
        [payButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [payButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
        payButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [footView addSubview:payButton];
        return footerView;
    } else if (_orderType == 2) {
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerID];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        footView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:footView];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 30)];
        priceLabel.font = [UIFont systemFontOfSize:11];
        priceLabel.text = @"订单金额:";
        [footView addSubview:priceLabel];
        UILabel *priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 60, 30)];
        priceLabel1.textColor = XZYSPinkColor;
        priceLabel1.font = [UIFont systemFontOfSize:11];
        priceLabel1.text = @"$1234567";
        [footView addSubview:priceLabel1];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [sureButton setTitle:@"确认收货" forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [sureButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
        [sureButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [footView addSubview:sureButton];
        
        UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6.5 - 20, 4, SCREEN_WIDTH / 6.5, 22);
        [orderButton setTitle:@"订单详情" forState:UIControlStateNormal];
        orderButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [orderButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
        [orderButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [footView addSubview:orderButton];
        return footerView;
    } else if (_orderType == 3) {
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerID];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        footView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:footView];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 30)];
        priceLabel.font = [UIFont systemFontOfSize:11];
        priceLabel.text = @"订单金额:";
        [footView addSubview:priceLabel];
        UILabel *priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 60, 30)];
        priceLabel1.textColor = XZYSPinkColor;
        priceLabel1.font = [UIFont systemFontOfSize:11];
        priceLabel1.text = @"$1234567";
        [footView addSubview:priceLabel1];
        
        UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [orderButton setTitle:@"订单详情" forState:UIControlStateNormal];
        orderButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [orderButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [orderButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
        [orderButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [footView addSubview:orderButton];
        return footerView;
    } else if (_orderType == 4) {
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerID];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        footView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:footView];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 30)];
        priceLabel.font = [UIFont systemFontOfSize:11];
        priceLabel.text = @"订单金额:";
        [footView addSubview:priceLabel];
        UILabel *priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 60, 30)];
        priceLabel1.textColor = XZYSPinkColor;
        priceLabel1.font = [UIFont systemFontOfSize:11];
        priceLabel1.text = @"$1234567";
        [footView addSubview:priceLabel1];
        
        UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [orderButton setTitle:@"订单详情" forState:UIControlStateNormal];
        orderButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [orderButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [orderButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
        [orderButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [footView addSubview:orderButton];
        return footerView;
    } else {
        
    }
    return nil;
}
- (void)deleteButtonClick {
    NSLog(@"delegate");
}
- (void)orderButtonClick {
    NSLog(@"order");
}
- (void)payButtonClick {
    NSLog(@"pay");
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainTab deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)allOrder:(id)sender {
    _orderType = 0;
    [self.allButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.lineView.frame = CGRectMake(10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self.mainTab reloadData];
}
- (IBAction)daiPay:(id)sender {
    _orderType = 1;
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self.mainTab reloadData];
}
- (IBAction)yiPay:(id)sender {
    _orderType = 3;
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 3 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self.mainTab reloadData];
}
- (IBAction)daiReceive:(id)sender {
    _orderType = 2;
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 2 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self.mainTab reloadData];
}
- (IBAction)yiComplate:(id)sender {
    _orderType = 4;
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 4 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self.mainTab reloadData];
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
