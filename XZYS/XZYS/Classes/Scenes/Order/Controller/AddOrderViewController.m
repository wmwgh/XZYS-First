//
//  AddOrderViewController.m
//  XZYS
//
//  Created by 杨利 on 16/9/29.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "AddOrderViewController.h"
#import "AddressViewController.h"
#import "XZYS_Other.h"
#import "AddOrderViewCell.h"
#import "XIangQingViewController.h"
#import "ShopCarModel.h"
#import "ShopViewController.h"
#import "AppDelegate.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD.h>
#import "OrderListViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString *headerID = @"HeaderSID";
static NSString *footerID = @"FooterSID";

@interface AddOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , copy) id orderTyp;

@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic , strong) UIButton *titleButton;
@property (nonatomic , strong) UILabel *titLabel;
@property (nonatomic , strong) UITableViewHeaderFooterView *footerView;
@property (nonatomic , strong) UIView *footView;
@property (nonatomic , strong) UITextField *messageText;
@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , assign) float max;
@property (nonatomic , strong) NSMutableDictionary *dataDic;
@property (nonatomic , strong) NSString *mainLab;
@end

@implementation AddOrderViewController

- (NSMutableArray *)cellAllary {
    if (!_cellAllary) {
        _cellAllary = [NSMutableArray array];
    }
    return _cellAllary;
}

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (void)viewDidLoad {
    self.title = @"确认订单";
    self.resultLab.text = self.resultPrice;
    [super viewDidLoad];
    [self setCollection];
    for (int i = 0; i < self.cellAllary.count; i++) {
        NSString *str = @"";
        [self.array addObject:str];
    }
    [self resqusetData];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setAdd:)
                                                 name:@"传地址"
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
   
}

#pragma pay  =======================
- (void)requestData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDele.userIdTag;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.orderTyp options:NSJSONWritingPrettyPrinted error:nil];
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
                resultMsg = @"交易成功";
                if ([self.whichVC isEqualToString:@"sp1"]) {
                    //发出通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifPayFinisha" object:self userInfo:nil];
                } else if ([self.whichVC isEqualToString:@"sp2"]) {
                    //发出通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifPayFinishb" object:self userInfo:nil];
                }
                
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

- (void)resqusetData {
    __weak typeof(self) weakSelf = self;
    weakSelf.dataArray = [NSMutableArray array];
    [weakSelf.dataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Address/getAddressAll" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id temp = responseObject[@"data"];
        if ([temp isKindOfClass:[NSArray class]]) {
            NSArray *arr = temp;
            for (NSDictionary *dic in arr) {
                if ([dic[@"is_default"] isEqualToString:@"1"]) {
                    self.nameLab.text = dic[@"consignee"];
                    self.phoneNumLab.text = dic[@"contact_info"];
                    self.addressLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@", dic[@"area_province_text"], dic[@"area_city_text"], dic[@"area_district_text"], dic[@"address"]];
                    self.resultID = dic[@"id"];
                }
            }
        } else {

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)setAdd:(NSNotification *)text {
    NSDictionary *dic = text.userInfo[@"sid"];
    self.nameLab.text = dic[@"1"];
    self.phoneNumLab.text = dic[@"2"];
    self.addressLab.text = dic[@"3"];
    self.resultID = dic[@"4"];
    
}

- (IBAction)tiJiao:(UIButton *)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:self.orderAllary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strjson1 = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:self.array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strjson2 = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    dic[@"uid"] = app.userIdTag;
    dic[@"cart_id"] = strjson1;
    dic[@"address_id"] = self.resultID;
    dic[@"remark"] = strjson2;
    if (dic[@"address_id"] != nil) {
        [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Order/orderAdd.html" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1];
            NSString *temp = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            if ([temp isEqualToString:@"-1300"]) {
#warning  tiao zhi fu
                NSString *jsonString = responseObject[@"data"];
                NSData *jData = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jData options:NSJSONReadingAllowFragments error:nil];
                NSArray *ary = jsonObject[@"order_ids"];
                self.orderTyp = ary;
                self.resultLab.text = @"0";
                self.cellAllary = nil;
                [self.navigationController popViewControllerAnimated:YES];
                [self requestData];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}


- (void)endEdit:(UITextField *)sender {
    for (int i = 0; i < self.cellAllary.count; i++) {
        if (sender.tag == i) {
            [self.array replaceObjectAtIndex:i withObject:sender.text];
        }
    }
}

- (void)setCollection {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, SCREEN_HEIGHT - 179) style:UITableViewStyleGrouped];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    self.mainTab.backgroundColor = XZYSRGBColor(230, 230, 230);
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([AddOrderViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.mainTab];
}

#pragma mark - Table view data sourceƒ

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellAllary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShopCarModel *model = [[ShopCarModel alloc] init];
    model = self.cellAllary[section];
    NSArray *ar = model.listArr;
    return ar.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCarModel *model1 = [[ShopCarModel alloc] init];
    model1 = self.cellAllary[indexPath.section];
    SonLislModel *model = [[SonLislModel alloc] init];
    model = model1.listArr[indexPath.row];
    AddOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    ShopCarModel *model1 = [[ShopCarModel alloc] init];
    model1 = self.cellAllary[indexPath.section];
    SonLislModel *model = [[SonLislModel alloc] init];
    model = model1.listArr[indexPath.row];
    xxVC.passID = model.goods_id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
    [self.mainTab deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
    UIView *backView = [[UIView alloc] init];
    
    backView.backgroundColor = XZYSRGBColor(244, 241, 242);
    [headerView addSubview:backView];
    UIImageView *dpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 25, 25)];
    dpImage.image = [UIImage imageNamed:@"dp_sd"];
    [backView addSubview:dpImage];
    
    self.titLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 145, 40)];
    self.titLabel.font = [UIFont systemFontOfSize:16];
    [backView bringSubviewToFront:self.titLabel];
    [backView addSubview:self.titLabel];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(45, 0, SCREEN_WIDTH - 40, 40);
    [self.titleButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(titleSBT:) forControlEvents:UIControlEventTouchUpInside];
    self.titleButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [backView addSubview:self.titleButton];
    
    UIImageView *jianimage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titLabel.frame), 12, 15, 17)];
    jianimage.image = [UIImage imageNamed:@"dp_ht"];
    [backView addSubview:jianimage];
    
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    SonLislModel *model = [[SonLislModel alloc] init];
    model = self.cellAllary[section];
    self.titLabel.text = model.shop_name;
    self.titleButton.tag = [model.shop_id intValue];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ShopCarModel *model1 = [[ShopCarModel alloc] init];
    model1 = self.cellAllary[section];
    SonLislModel *model = [[SonLislModel alloc] init];
    NSArray *ar = model1.listArr;
    self.max = 0;
    for (model in ar) {
        float a = [model.price floatValue];
        int b = [model.num floatValue];
        self.max += a * b;
    }
    _footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    _footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerID];
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62)];
    UILabel *maiLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 60, 18)];
    maiLab.text = @"买家留言";
    maiLab.font = [UIFont systemFontOfSize:13];
    maiLab.textColor = XZYSPinkColor;
    [_footView addSubview:maiLab];
    self.messageText = [[UITextField alloc] init];
    self.messageText.font = [UIFont systemFontOfSize:13];
    self.messageText.frame = CGRectMake(65, 7, SCREEN_WIDTH - 80, 18);
    self.messageText.placeholder = @"选填，方便您与卖家达成一致";
    self.messageText.tag = section;
    self.messageText.textColor = [UIColor lightGrayColor];
    [self.messageText addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEnd];
    [_footView addSubview:self.messageText];
    UIView *underView = [[UIView alloc] initWithFrame:CGRectMake(5, 33, SCREEN_WIDTH - 10, 1)];
    underView.backgroundColor = XZYSRGBColor(234, 234, 234);
    [_footView addSubview:underView];
    
    UILabel *heji = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 140, 38, 35, 20)];
    heji.text = @"合计:";
    heji.font = [UIFont systemFontOfSize:13];
    
    [_footView addSubview:heji];
    
    UILabel *pric = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 38, 110, 20)];
    pric.text = [NSString stringWithFormat:@"￥%.2f", self.max];
    pric.font = [UIFont systemFontOfSize:13];
    pric.textColor = XZYSPinkColor;
    [_footView addSubview:pric];
    _footView.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:_footView];
    return _footerView;
}
- (void)titleSBT:(UIButton *)sender {
    ShopViewController *shopVC = [[ShopViewController alloc] init];
    shopVC.shopID = [NSString stringWithFormat:@"%ld", sender.tag];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (IBAction)chooseAddress:(UIButton *)sender {
    AddressViewController *addADSVC = [[AddressViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addADSVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
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
