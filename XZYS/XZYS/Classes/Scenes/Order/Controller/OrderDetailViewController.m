//
//  OrderDetailViewController.m
//  XZYS
//
//  Created by 杨利 on 16/9/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "OrderDetailViewController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import "XZYS_Other.h"
#import "AllListModel.h"
#import "SonLislModel.h"
#import "AllOrderListCell.h"
#import "OrderDetailViewController.h"

static NSString *headerID = @"cityHeaderSectionID";
static NSString *footerID = @"cityFooterSectionID";

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *cellAllay;

@property (strong, nonatomic) IBOutlet UILabel *dingDanHao;
@property (strong, nonatomic) IBOutlet UILabel *xiaDanTime;
@property (strong, nonatomic) IBOutlet UILabel *chuHuo;
@property (strong, nonatomic) IBOutlet UILabel *zhuangTai;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic , strong) AllListModel *model;
@property (nonatomic , strong) UITableViewHeaderFooterView *footerView;
@property (nonatomic , strong) UIView *footView;
@property (nonatomic , strong) UIButton *deleteButton;
@property (nonatomic , strong) UIButton *orderButton;
@property (nonatomic , strong) UIButton *payButton;
@property (nonatomic , strong) UIButton *sureButton;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTab];
    [self requestAllData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setTab {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 174, SCREEN_WIDTH, SCREEN_HEIGHT - 174) style:UITableViewStyleGrouped];
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([AllOrderListCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    [self.view addSubview:self.mainTab];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellAllay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SonLislModel *model = [[SonLislModel alloc] init];
    model = self.cellAllay[indexPath.section];
    AllOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    UIImageView *dpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 25, 25)];
    dpImage.image = [UIImage imageNamed:@"dp_sd"];
    [backView addSubview:dpImage];
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 145, 40)];
    titLabel.font = [UIFont systemFontOfSize:14];
    [backView bringSubviewToFront:titLabel];
    [backView addSubview:titLabel];
    UIImageView *jianimage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titLabel.frame), 12, 15, 17)];
    jianimage.image = [UIImage imageNamed:@"dp_ht"];
    [backView addSubview:jianimage];
    titLabel.text = self.model.shop_name;
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
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
    priceLabel1.text = _model.total_price;
    [_footView addSubview:priceLabel1];
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
//    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    [_deleteButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [_payButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
//    [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    _payButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setTitle:@"确认收货" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize: 11.0];
//    [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    [_sureButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    if ([_model.order_status_text isEqualToString:@"未付款"]) {
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_deleteButton];
        _payButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6.5 - 20, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_payButton];
        return _footerView;
    } else if ([_model.order_status_text isEqualToString:@"已发货"]) {
        _sureButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6.5 - 10, 4, SCREEN_WIDTH / 6.5, 22);
        [_footView addSubview:_sureButton];
        return _footerView;
    }
    return _footerView;
}

-(void)requestAllData {
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    _titleArray = [NSMutableArray array];
    [_titleArray removeAllObjects];
    _cellAllay = [NSMutableArray array];
    [_cellAllay removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDele.userIdTag;
    params[@"order_id"] = self.orderID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Order/orderDelivery.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        //获取数据源
        self.model = [[AllListModel alloc] init];
        [self.model setValuesForKeysWithDictionary:dic];
        self.dingDanHao.text = self.model.order_sn;
        self.xiaDanTime.text = self.model.create_time;
        self.chuHuo.text = self.model.delivery_cycle;
        self.zhuangTai.text = self.model.order_status_text;
        self.nameLabel.text = self.model.consignee;
        self.numLabel.text = self.model.telephone;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.model.province, self.model.city, self.model.county, self.model.payment];
        [self.titleArray addObject:self.model];
        NSArray *arr = dic[@"goods_list"];
        for (NSDictionary *dic1 in arr) {
            SonLislModel *sonModel = [[SonLislModel alloc] init];
            [sonModel setValuesForKeysWithDictionary:dic1];
            [self.cellAllay addObject:sonModel];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
