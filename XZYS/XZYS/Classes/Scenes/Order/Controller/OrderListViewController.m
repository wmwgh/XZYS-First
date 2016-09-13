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
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import "AllListModel.h"
#import "SonLislModel.h"
#import "OrderDetailViewController.h"
#import <MBProgressHUD.h>

static NSString *headerID = @"cityHeaderSectionID";
static NSString *footerID = @"cityFooterSectionID";
@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic , strong) NSMutableArray *allDataArray;
@property (nonatomic , strong) UILabel *nomalLabel;
@property (nonatomic , strong) UIImageView *dpImage;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *cellAllay;
@property (nonatomic , strong) UITableViewHeaderFooterView *footerView;
@property (nonatomic , strong) UIView *footView;
@property (nonatomic , strong) UIButton *deleteButton;
@property (nonatomic , strong) UIButton *orderButton;
@property (nonatomic , strong) UIButton *payButton;
@property (nonatomic , strong) UIButton *sureButton;
@property (nonatomic , strong) NSMutableDictionary *params;
@end

@implementation OrderListViewController
- (NSMutableArray *)allDataArray {
    if (_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单管理";
    [self setButton];
    [self setNav];
    [self requestAllData];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
}

- (void)requestAllData {
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    _titleArray = [NSMutableArray array];
    [_titleArray removeAllObjects];
    _cellAllay = [NSMutableArray array];
    [_cellAllay removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_orderType == 0) {
        params[@"status"] = @"1";
    } else if (_orderType == 1) {
        params[@"status"] = @"100";
    } else if (_orderType == 2) {
        params[@"status"] = @"102";
    } else if (_orderType == 3) {
        params[@"status"] = @"112";
    } else if (_orderType == 4) {
        params[@"status"] = @"122";
    }
    
    AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDele.userIdTag;
    NSLog(@"%@", params);
        [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Order/orderList.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *NVArray = responseObject[@"data"];
            if (NVArray) {
                //获取数据源
                for (NSDictionary *dic1 in NVArray) {
                    NSMutableArray *arra = [NSMutableArray array];
                    AllListModel *model = [[AllListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [self.titleArray addObject:model];
                    NSArray *arr = dic1[@"goods_list"];
                    for (NSDictionary *dic2 in arr) {
                        SonLislModel *sonModel = [[SonLislModel alloc] init];
                        [sonModel setValuesForKeysWithDictionary:dic2];
                        [arra addObject:sonModel];
                    }
                    [self.cellAllay addObject:arra];
                }
            }
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
        [self.mainTab reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
}

- (void)setNav {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 110) style:UITableViewStyleGrouped];
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([AllOrderListCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([DaiOrderListCell class]) bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([DaiOrderListCell class]) bundle:nil] forCellReuseIdentifier:@"cell2"];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    [self.view addSubview:self.mainTab];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AllListModel *allModel = [[AllListModel alloc] init];
    allModel = self.titleArray[section];
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
    detailVC.orderID = allModel.ID;;
    
    NSArray *arr = self.cellAllay[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SonLislModel *model = [[SonLislModel alloc] init];
    NSArray *array = self.cellAllay[indexPath.section];
    model = array[indexPath.row];
    if (_orderType == 0) {
        AllListModel *allModel = [[AllListModel alloc] init];
        allModel = self.titleArray[indexPath.section];
        if ([allModel.order_status_text isEqualToString:@"已完成"]) {
            DaiOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            [cell setModel:model];
            cell.shouhou.tag = [model.ID integerValue];
            cell.tiaohuo.tag = [model.ID integerValue];
            return cell;
        }
    }
    
    if (_orderType == 4) {
        DaiOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell setModel:model];
        cell.shouhou.tag = [model.ID integerValue];
        cell.tiaohuo.tag = [model.ID integerValue];
        return cell;
    } else {
        AllOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}
- (void)titleBT:(UIButton *)sender {
    NSLog(@"title");
}
- (void)deleteButtonClick:(UIButton *)sender {
    self.params = [NSMutableDictionary dictionary];
    self.params[@"order_id"] = [NSString stringWithFormat:@"%ld", sender.tag];
//    self.params[@"order_id"] = @"9";
    self.params[@"act"] = @"order_del";
    
    [self orderAction];
}
- (void)orderButtonClick:(UIButton *)sender {
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
    detailVC.orderID = [NSString stringWithFormat:@"%ld", sender.tag];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)payButtonClick:(UIButton *)sender {
    NSLog(@"pay");
}

- (void)sureButtonClick:(UIButton *)sender {
    NSLog(@"sure");
}

- (void)orderAction {
    AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
    _params[@"uid"] = appDele.userIdTag;
//    _params[@"uid"] = @"1";
    NSLog(@"%@", _params);
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Order/orderOperationReception.html" parameters:_params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSDictionary *dic = responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-1309"]){
            hud.labelText = dic[@"msg"];
            [self requestAllData];
        } else {
            hud.labelText = dic[@"msg"];
        }
        NSLog(@"request:%@", dic[@"msg"]);
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
        // 隐藏指示器
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
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
    [self requestAllData];
}
- (IBAction)daiPay:(id)sender {
    _orderType = 1;
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self requestAllData];
}
- (IBAction)yiPay:(id)sender {
    _orderType = 3;
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 3 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self requestAllData];
}
- (IBAction)daiReceive:(id)sender {
    _orderType = 2;
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 2 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self requestAllData];
}
- (IBAction)yiComplate:(id)sender {
    _orderType = 4;
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 4 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self requestAllData];
}

#pragma 头尾视图
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
    [titleButton addTarget:self action:@selector(titleBT:) forControlEvents:UIControlEventTouchUpInside];
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
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        titleButton.tag = [model.ID integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
#pragma maik ------ 待收货订单
    } else if (_orderType == 2) {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        titleButton.tag = [model.ID integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
#pragma maik ------ 已付款订单
    } else if (_orderType == 3) {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        titleButton.tag = [model.ID integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
#pragma maik ------ 已完成订单
    } else if (_orderType == 4) {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        titleButton.tag = [model.ID integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
    } else {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        titleButton.tag = [model.ID integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    AllListModel *model = [[AllListModel alloc] init];
    model = self.titleArray[section];
    _footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    _footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerID];
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    _footView.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:_footView];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 30)];
    priceLabel.font = [UIFont systemFontOfSize:11];
    priceLabel.text = @"订单金额:";
    [_footView addSubview:priceLabel];
    UILabel *priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 60, 30)];
    priceLabel1.textColor = XZYSPinkColor;
    priceLabel1.font = [UIFont systemFontOfSize:11];
    priceLabel1.text = model.total_price;
    [_footView addSubview:priceLabel1];
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    [_deleteButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_orderButton setTitle:@"订单详情" forState:UIControlStateNormal];
    _orderButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    [_orderButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    [_orderButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [_payButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    _payButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setTitle:@"确认收货" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    [_sureButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    
    if (_orderType == 1) {
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_deleteButton];
        _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6.5 - 20, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_orderButton];
        _payButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 3 / 6.5 - 30, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_payButton];
        _deleteButton.tag = [model.ID integerValue];
        _payButton.tag = [model.ID integerValue];
        _orderButton.tag = [model.ID integerValue];
        _sureButton.tag = [model.ID integerValue];
        return _footerView;
    } else if (_orderType == 2) {
        _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_orderButton];
        _deleteButton.tag = [model.ID integerValue];
        _payButton.tag = [model.ID integerValue];
        _orderButton.tag = [model.ID integerValue];
        _sureButton.tag = [model.ID integerValue];
        return _footerView;
    } else if (_orderType == 3) {
        _sureButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_sureButton];
        _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6.5 - 20, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_orderButton];
        _deleteButton.tag = [model.ID integerValue];
        _payButton.tag = [model.ID integerValue];
        _orderButton.tag = [model.ID integerValue];
        _sureButton.tag = [model.ID integerValue];
        return _footerView;
    } else if (_orderType == 4) {
        _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_orderButton];
        _deleteButton.tag = [model.ID integerValue];
        _payButton.tag = [model.ID integerValue];
        _orderButton.tag = [model.ID integerValue];
        _sureButton.tag = [model.ID integerValue];
        return _footerView;
    } else {
        if ([model.order_status_text isEqualToString:@"未付款"]) {
            _deleteButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
            [_footView addSubview:_deleteButton];
            _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6.5 - 20, 4, SCREEN_WIDTH / 6.5, 22);
            [_footView addSubview:_orderButton];
            _payButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 3 / 6.5 - 30, 4, SCREEN_WIDTH / 6.5, 22);
            [_footView addSubview:_payButton];
            _deleteButton.tag = [model.ID integerValue];
            _payButton.tag = [model.ID integerValue];
            _orderButton.tag = [model.ID integerValue];
            _sureButton.tag = [model.ID integerValue];
            return _footerView;
        } else if ([model.order_status_text isEqualToString:@"已发货"]) {
            _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
            _deleteButton.tag = [model.ID integerValue];
            _payButton.tag = [model.ID integerValue];
            _orderButton.tag = [model.ID integerValue];
            _sureButton.tag = [model.ID integerValue];            [_footView addSubview:_orderButton];
            return _footerView;
        } else if ([model.order_status_text isEqualToString:@"已完成"]) {
            _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
            _deleteButton.tag = [model.ID integerValue];
            _payButton.tag = [model.ID integerValue];
            _orderButton.tag = [model.ID integerValue];
            _sureButton.tag = [model.ID integerValue];            [_footView addSubview:_orderButton];
            return _footerView;
        } else if ([model.order_status_text isEqualToString:@"已付款"]) {
            _sureButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
            [_footView addSubview:_sureButton];
            _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6.5 - 20, 4, SCREEN_WIDTH / 6.5, 22);
            _deleteButton.tag = [model.ID integerValue];
            _payButton.tag = [model.ID integerValue];
            _orderButton.tag = [model.ID integerValue];
            _sureButton.tag = [model.ID integerValue];
            [_footView addSubview:_orderButton];
            return _footerView;
        }
    }
    return nil;
}

// 按钮
- (void)setButton {
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = XZYSBlueColor;
    [self.view addSubview:self.lineView];
    
    if (_orderType == 0) {
        [self.allButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.lineView.frame = CGRectMake(10, 105, SCREEN_WIDTH / 5 - 20, 3);
    } else if (_orderType == 1) {
        [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    } else if (_orderType == 2) {
        [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 2 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    } else if (_orderType == 3) {
        [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.yiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
        [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 3 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    } else if (_orderType == 4) {
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
