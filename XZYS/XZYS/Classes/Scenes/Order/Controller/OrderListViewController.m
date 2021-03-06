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
#import "RequestTiaoHuoController.h"
#import "RequestShouHouController.h"
#import "ShopViewController.h"
#import "XIangQingViewController.h"
#import <MJRefresh.h>

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


static NSString *headerID = @"cityHeaderSectionID";
static NSString *footerID = @"cityFooterSectionID";
@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , copy) id orderTyp;

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
@property (nonatomic , strong) NSMutableDictionary *dataParams;
@property (nonatomic , strong) NSMutableDictionary *idDic;
@property (nonatomic , assign) NSInteger sectionID;
@property (nonatomic , assign) NSInteger rowID;
@property (nonatomic , strong) UIButton *titleButton;
@property (nonatomic , strong) NSMutableDictionary *dataDic;
@property (nonatomic , strong) NSString *mainLab;
/** 页码*/
@property (nonatomic, assign) int page;

@end

@implementation OrderListViewController
- (NSMutableDictionary *)dataParams {
    if (_dataParams) {
        _dataParams = [NSMutableDictionary dictionary];
    }
    return _dataParams;
}
- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
- (NSMutableArray *)allDataArray {
    if (_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (NSMutableDictionary *)idDic {
    if (_idDic) {
        _idDic = [NSMutableDictionary dictionary];
    }
    return _idDic;
}

- (void)msgAction {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"支付成功";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma pay  =======================
- (void)requestData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDele.userIdTag;
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:self.orderTyp];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strjson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"order_id"] = strjson;
    params[@"paytype"] = @"Alipayapp";
    
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Payment/paymentRequest" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dataDic = responseObject[@"data"];
        [self setPay];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)setPay {
    // 这里的三个参数是公司和支付宝签约之后得到的，没有这三个参数无法完成支付
    NSString *seller_id = self.dataDic[@"seller_id"];
    NSString *partner = self.dataDic[@"partner"];
    NSString *privateKey = self.dataDic[@"sign"];
    
    
    //    NSString *newsign = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)privateKey, NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));
    
    //partner和seller获取失败,提示
    //partner和seller获取失败,提示
    if ([seller_id length] == 0 ||
        [partner length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [Order new];
    
    order.partner = self.dataDic[@"partner"];
    order.body = self.dataDic[@"body"];
    order.seller_id = self.dataDic[@"seller_id"];
    order.out_trade_no = self.dataDic[@"out_trade_no"];
    order.subject = self.dataDic[@"subject"];
    order.service = self.dataDic[@"service"];
    order.notify_url = self.dataDic[@"notify_url"];
    order.payment_type = self.dataDic[@"payment_type"];
    order.total_fee = self.dataDic[@"total_fee"];
    order._input_charset = self.dataDic[@"_input_charset"];
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order description];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"app.XZYS";
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    //        id<DataSigner> signer = CreateRSADataSigner(privateKeyA);
    //        NSString *signedString = [signer signString:orderInfo];
    
    
    //    NSString *signedString = @"";
    // NOTE: 如果加签成功，则继续执行支付
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (orderInfo != nil) {
        //    NSString *orderString = nil;
        //    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderInfo, privateKey, @"RSA"];
        NSLog(@"%@", orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
            NSString *resultMsg = @"";
            if (resultStatus == 9000) {//交易成功
                self.page = 1;
                _orderType = 2;
                [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.daiReceive setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
                [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 2 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
                [self requestAllData];
                resultMsg = @"交易成功";
            } else if (resultStatus == 8000) {
                resultMsg = @"订单正在处理中";
            } else if (resultStatus == 4000) {
                resultMsg = @"订单支付失败";
            } else if (resultStatus == 6001) {
                resultMsg = @"用户中途取消";
            } else if (resultStatus == 6002) {
                resultMsg = @"网络连接出错";
            } else {
                resultMsg = @"交易失败";
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = resultMsg;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }];
    }
    
    /*
     以下是几个回调返回的resultDic值：
     
     9000 订单支付成功
     8000 正在处理中
     4000 订单支付失败
     6001 用户中途取消
     6002 网络连接出错
     */
    
    // Do any additional setup after loading the view from its nib.
}

-(void)orderpayok {
    self.page = 1;
    _orderType = 2;
    self.payResultMSG = @"支付成功";
    self.payResultMSGAction = @"101";
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 * 2 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self requestAllData];
}

-(void)orderpayfaile {
    self.page = 1;
    _orderType = 1;
    self.payResultMSG = @"支付失败";
    self.payResultMSGAction = @"101";
    [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.daiPay setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.daiReceive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yiPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lineView.frame = CGRectMake(SCREEN_WIDTH / 5 + 10, 105, SCREEN_WIDTH / 5 - 20, 3);
    [self requestAllData];
}

- (void)payButtonClick:(UIButton *)sender {
    AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
    self.params = [NSMutableDictionary dictionary];
    self.params[@"uid"] = appDele.userIdTag;
    self.params[@"order_id"] = [NSString stringWithFormat:@"%ld", sender.tag];
//    [self orderAction];
    self.orderTyp = [NSString stringWithFormat:@"%ld", sender.tag];
    [self requestData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单管理";
    self.page = 1;
    [self setButton];
    [self setNav];
    
//    [self requestAllData];
    // 添加顶部刷新
    [self addRefresh];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(cellCallBack:)
                                                 name: @"调货跳转"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(cellShouHou:)
                                                 name: @"申请售后"
                                               object: nil];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderCallBack)
                                                 name:@"申请调货刷新UI"
                                               object:nil];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelCallBack:)
                                                 name:@"取消刷新UI"
                                               object:nil];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sureCallBack:)
                                                 name:@"收获刷新UI"
                                               object:nil];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderpayok)
                                                 name:@"付款刷新UI"
                                               object:nil];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderpayfaile)
                                                 name:@"付款失败刷新UI"
                                               object:nil];
}

- (void)addRefresh {
    
    self.mainTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestAllData)];
    self.mainTab.mj_header.automaticallyChangeAlpha = YES;
    [self.mainTab.mj_header beginRefreshing];
    self.mainTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreDataShop)];
}

- (void)requestMoreDataShop {
    __weak typeof(self) weakSelf = self;
    self.page++;
    //请求参数
    weakSelf.dataParams[@"page"] = [NSString stringWithFormat:@"%d", self.page];
    /// collection 数据请求
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Order/orderList.html" parameters:weakSelf.dataParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *NVArray = responseObject[@"data"];
        if (![NVArray isEqual:@""]) {
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
        } else {
            //结束刷新
            [self.mainTab.mj_footer endRefreshing];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"商品已全部更新";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        [self.mainTab reloadData];
        [self.mainTab.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络异常，加载失败！";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }];
}

//- (void)payCallBack:(NSNotification *)text {
//    NSLog(@"%@", text.userInfo[@"sid"]);
//    NSString *str = text.userInfo[@"sid"];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = str;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:1];
//}

- (void)sureCallBack:(NSNotification *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"确认收货成功";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
    self.params = [NSMutableDictionary dictionary];
    self.params[@"order_id"] = text.userInfo[@"sid"];
    self.params[@"act"] = @"shipping_complete";
    
    [self orderAction];
}

- (void)cancelCallBack:(NSNotification *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"取消订单成功";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
    self.params = [NSMutableDictionary dictionary];
    self.params[@"order_id"] = text.userInfo[@"sid"];
    self.params[@"act"] = @"cancel";
    
    [self orderAction];
}

- (void)orderCallBack {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"申请调货成功";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)cellShouHou:(id)sender {
    AllListModel *allModel = self.titleArray[self.sectionID];
    RequestShouHouController *requestVC = [[RequestShouHouController alloc] init];
    NSArray *ar = self.cellAllay[self.sectionID];
    SonLislModel *sonModel = ar[self.rowID];
    requestVC.orderID = allModel.ID;
    requestVC.goodsID = sonModel.ID;
    [self.navigationController pushViewController:requestVC animated:YES];
}

- (void)cellCallBack:(id)sender {
    AllListModel *allModel = self.titleArray[self.sectionID];
    RequestTiaoHuoController *requestVC = [[RequestTiaoHuoController alloc] init];
    NSArray *ar = self.cellAllay[self.sectionID];
    SonLislModel *sonModel = ar[self.rowID];
    requestVC.orderID = allModel.ID;
    requestVC.goodsID = sonModel.ID;
    [self.navigationController pushViewController:requestVC animated:YES];
}

- (void)requestAllData {
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
    
        [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Order/orderList.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *NVArray = responseObject[@"data"];
            if (![NVArray isEqual:@""]) {
                //获取数据源
                for (NSDictionary *dic1 in NVArray) {
                    NSMutableArray *arra = [NSMutableArray array];
                    AllListModel *model = [[AllListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [self.titleArray addObject:model];
                    NSArray *arr = dic1[@"goods_list"];
                    if (arr != nil && ![arr isKindOfClass:[NSNull class]] && arr.count != 0) {
                        for (NSDictionary *dic2 in arr) {
                            SonLislModel *sonModel = [[SonLislModel alloc] init];
                            [sonModel setValuesForKeysWithDictionary:dic2];
                            [arra addObject:sonModel];
                        }
                    } else if (arr == nil && [arr isKindOfClass:[NSNull class]] && arr.count == 0) {
                        SonLislModel *sonModel = [[SonLislModel alloc] init];
                        sonModel.ID = @"";
                        sonModel.goods_id = @"";
                        sonModel.goods_name = @"正在等待审核";
                        sonModel.goods_img = @"";
                        sonModel.goods_color = @"";
                        sonModel.goods_size = @"";
                        sonModel.num = @"";
                        sonModel.price = @"";
                        sonModel.goods_subtotal = @"";
                        [arra addObject:sonModel];
                    }
                    [self.cellAllay addObject:arra];
                }
                if ([self.payResultMSGAction isEqualToString:@"101"]) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = self.payResultMSG;
                    // 隐藏时候从父控件中移除
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    self.payResultMSG = @"";
                    self.payResultMSGAction = @"";
                } else {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"订单列表已更新";
                    // 隐藏时候从父控件中移除
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                }
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"还未添加任何商品";
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
        [self.mainTab reloadData];
        [self.mainTab.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络异常，加载失败！";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
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
#warning block
            DaiOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            [cell setModel:model];
            [cell handlerButtonAction:^(UIButton *superID) {
                DaiOrderListCell *cell = (DaiOrderListCell *)[[superID superview] superview];
                NSIndexPath *path = [self.mainTab indexPathForCell:cell];
                self.sectionID = [path section];
                self.rowID = [path row];
            }];
            
            return cell;
        }
    }
    
    if (_orderType == 4) {
        DaiOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell setModel:model];
        [cell handlerButtonAction:^(UIButton *superID) {
            UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
            butn = superID;
            DaiOrderListCell *cell = (DaiOrderListCell *)[[superID superview] superview];
            NSIndexPath *path = [self.mainTab indexPathForCell:cell];
            self.sectionID = [path section];
            self.rowID = [path row];
        }];
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
    ShopViewController *shopVC = [[ShopViewController alloc] init];
    shopVC.shopID = [NSString stringWithFormat:@"%ld", sender.tag];
    [self.navigationController pushViewController:shopVC animated:YES];
}

- (void)deleteButtonClick:(UIButton *)sender {
    self.params = [NSMutableDictionary dictionary];
    self.params[@"order_id"] = [NSString stringWithFormat:@"%ld", sender.tag];
    self.params[@"act"] = @"cancel";
    [self orderAction];
}
- (void)orderButtonClick:(UIButton *)sender {
    
    AllListModel *allModel = [[AllListModel alloc] init];
    allModel = self.titleArray[self.sectionID];
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
    detailVC.orderID = [NSString stringWithFormat:@"%ld", sender.tag];
    //    detailVC.shopID = [NSString stringWithFormat:@"%ld", _titleButton.tag];
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)sureButtonClick:(UIButton *)sender {
    self.params = [NSMutableDictionary dictionary];
    self.params[@"order_id"] = [NSString stringWithFormat:@"%ld", sender.tag];
    self.params[@"act"] = @"shipping_complete";
    [self orderAction];
}

- (void)orderAction {
    AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
    _params[@"uid"] = appDele.userIdTag;
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
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
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
    XIangQingViewController *xqVC = [[XIangQingViewController alloc] init];
    NSArray *ar = self.cellAllay[indexPath.section];
    SonLislModel *model = ar[indexPath.row];
    xqVC.passID = model.goods_id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xqVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (IBAction)allOrder:(id)sender {
    self.page = 1;
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
    self.page = 1;
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
    self.page = 1;
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
    self.page = 1;
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
    self.page = 1;
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
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(45, 0, SCREEN_WIDTH - 140, 40);
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 145, 40)];
    titLabel.font = [UIFont systemFontOfSize:16];
    [backView bringSubviewToFront:titLabel];
    [backView addSubview:titLabel];
    [_titleButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [_titleButton addTarget:self action:@selector(titleBT:) forControlEvents:UIControlEventTouchUpInside];
    _titleButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [_titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [backView addSubview:_titleButton];
    UIImageView *jianimage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleButton.frame), 12, 15, 17)];
    jianimage.image = [UIImage imageNamed:@"dp_ht"];
    [backView addSubview:jianimage];
    self.nomalLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 58, 7, 50, 30)];
    self.nomalLabel.textColor = XZYSPinkColor;
    self.nomalLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:self.nomalLabel];
    if (_orderType == 1) {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        _titleButton.tag = [model.shop_id integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
#pragma maik ------ 待收货订单
    } else if (_orderType == 2) {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        _titleButton.tag = [model.shop_id integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
#pragma maik ------ 已付款订单
    } else if (_orderType == 3) {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        _titleButton.tag = [model.shop_id integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
#pragma maik ------ 已完成订单
    } else if (_orderType == 4) {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        _titleButton.tag = [model.shop_id integerValue];
        self.nomalLabel.text = model.order_status_text;
        return headerView;
    } else {
        AllListModel *model = [[AllListModel alloc] init];
        model = self.titleArray[section];
        titLabel.text = model.shop_name;
        _titleButton.tag = [model.shop_id integerValue];
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
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 65, 30)];
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.text = @"订单金额:";
    [_footView addSubview:priceLabel];
    UILabel *priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(67, 0, 98, 30)];
    priceLabel1.textColor = XZYSPinkColor;
    priceLabel1.font = [UIFont systemFontOfSize:13];
    priceLabel1.text = model.total_price;
    [_footView addSubview:priceLabel1];
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setTitle:@"取消订单" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    [_deleteButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_orderButton setTitle:@"订单详情" forState:UIControlStateNormal];
    _orderButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_orderButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    [_orderButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [_payButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    _payButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setTitle:@"确认收货" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton setBackgroundImage:[UIImage imageNamed:@"dd_bk"] forState:UIControlStateNormal];
    [_sureButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    
    if (_orderType == 1) {
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6 - 10, 4, SCREEN_WIDTH / 6, 22);
        [_footView addSubview:_deleteButton];
        _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6 - 20, 4, SCREEN_WIDTH / 6, 22);
        [_footView addSubview:_orderButton];
        _payButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 3 / 6 - 30, 4, SCREEN_WIDTH / 6, 22);
        [_footView addSubview:_payButton];
        _deleteButton.tag = [model.ID integerValue];
        _payButton.tag = [model.ID integerValue];
        _orderButton.tag = [model.ID integerValue];
        _sureButton.tag = [model.ID integerValue];
        return _footerView;
    } else if (_orderType == 2) {
        _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6 - 10, 4, SCREEN_WIDTH / 6, 22);
        [_footView addSubview:_orderButton];
        _deleteButton.tag = [model.ID integerValue];
        _payButton.tag = [model.ID integerValue];
        _orderButton.tag = [model.ID integerValue];
        _sureButton.tag = [model.ID integerValue];
        return _footerView;
    } else if (_orderType == 3) {
        _sureButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6 - 10, 4, SCREEN_WIDTH / 6, 22);
        [_footView addSubview:_sureButton];
        _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6 - 20, 4, SCREEN_WIDTH / 6, 22);
        [_footView addSubview:_orderButton];
        _deleteButton.tag = [model.ID integerValue];
        _payButton.tag = [model.ID integerValue];
        _orderButton.tag = [model.ID integerValue];
        _sureButton.tag = [model.ID integerValue];
        return _footerView;
    } else if (_orderType == 4) {
        _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6 - 10, 4, SCREEN_WIDTH / 6, 22);
        [_footView addSubview:_orderButton];
        _deleteButton.tag = [model.ID integerValue];
        _payButton.tag = [model.ID integerValue];
        _orderButton.tag = [model.ID integerValue];
        _sureButton.tag = [model.ID integerValue];
        return _footerView;
    } else {
        if ([model.order_status_text isEqualToString:@"未付款"]) {
            _deleteButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6 - 10, 4, SCREEN_WIDTH / 6, 22);
            [_footView addSubview:_deleteButton];
            _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6 - 20, 4, SCREEN_WIDTH / 6, 22);
            [_footView addSubview:_orderButton];
            _payButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 3 / 6 - 30, 4, SCREEN_WIDTH / 6, 22);
            [_footView addSubview:_payButton];
            _deleteButton.tag = [model.ID integerValue];
            _payButton.tag = [model.ID integerValue];
            _orderButton.tag = [model.ID integerValue];
            _sureButton.tag = [model.ID integerValue];
            return _footerView;
        } else if ([model.order_status_text isEqualToString:@"已发货"]) {
            _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6 - 10, 4, SCREEN_WIDTH / 6, 22);
            _deleteButton.tag = [model.ID integerValue];
            _payButton.tag = [model.ID integerValue];
            _orderButton.tag = [model.ID integerValue];
            _sureButton.tag = [model.ID integerValue];            [_footView addSubview:_orderButton];
            return _footerView;
        } else if ([model.order_status_text isEqualToString:@"已完成"]) {
            _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6 - 10, 4, SCREEN_WIDTH / 6, 22);
            _deleteButton.tag = [model.ID integerValue];
            _payButton.tag = [model.ID integerValue];
            _orderButton.tag = [model.ID integerValue];
            _sureButton.tag = [model.ID integerValue];            [_footView addSubview:_orderButton];
            return _footerView;
        } else if ([model.order_status_text isEqualToString:@"已付款"]) {
            _sureButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6 - 10, 4, SCREEN_WIDTH / 6, 22);
            [_footView addSubview:_sureButton];
            _orderButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * 2 / 6 - 20, 4, SCREEN_WIDTH / 6, 22);
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
