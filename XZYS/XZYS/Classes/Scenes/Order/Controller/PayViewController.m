//
//  PayViewController.m
//  XZYS
//
//  Created by 杨利 on 16/9/14.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "PayViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "OrderListViewController.h"

#define pubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDnI7NbBKIQEKOXuzzNMyOaueImHykr+6vVWSXWCUZJiSovgvTtYNjQV9eEk2ZHjii+LxHzt8Qf3vRvkT6MOtTl+gzRMk0qwI/Lpsz1ZPcMHuAdmMSgCFPYj0nCN5KRszX6GxggZa3wIU54b9ea5vbLuxnDMd8F/WyG48S+X5vjtwIDAQAB"

@interface PayViewController ()
@property (nonatomic , strong) NSMutableDictionary *dataDic;
@property (nonatomic , strong) UILabel *mainLab;
@end

@implementation PayViewController

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.mainLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, [UIScreen mainScreen].bounds.size.width - 40, 20)];
    self.mainLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.mainLab];
    self.mainLab.hidden = YES;
    [self requestData];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(payCallBack:)  name:@"notifPayFinish"
                                                   object:nil];
}

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
    
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)privateKey, NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order description];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"app.XZYS";
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
//        id<DataSigner> signer = CreateRSADataSigner(AliPrviteKey);
//        NSString *signedString = [signer signString:orderInfo];
    
    
//    NSString *signedString = @"";
    // NOTE: 如果加签成功，则继续执行支付
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (orderInfo != nil) {
//    NSString *orderString = nil;
//    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderInfo, newString, @"RSA"];
        
//        NSLog(@"---------------------------------------%@", orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"++++++++++++++++++++++++++++++++++%@",resultDic[@"memo"]);
//            NSLog(@"++++++++++++++++++++++++++++++++++%@",resultDic);
            NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
            NSString *resultMsg = @"";
            if (resultStatus == 9000) {//交易成功
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
            self.mainLab.text = resultMsg;
            self.mainLab.hidden = NO;
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

- (void)payCallBack:(NSNotification *)text {
    NSString *tagID = text.userInfo[@"sid"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tagID;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    self.mainLab.text = tagID;
    self.mainLab.hidden = NO;
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
