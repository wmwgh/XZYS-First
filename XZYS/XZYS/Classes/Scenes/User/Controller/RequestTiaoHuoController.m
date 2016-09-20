//
//  RequestTiaoHuoController.m
//  XZYS
//
//  Created by 杨利 on 16/9/11.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "RequestTiaoHuoController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>
@interface RequestTiaoHuoController ()

@end

@implementation RequestTiaoHuoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请调货";
    // Do any additional setup after loading the view from its nib.
}


// Do any additional setup after loading the view from its nib.


- (void)requestData {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = appDelegate.userIdTag;
    param[@"order_id"] = self.orderID;
    param[@"order_goods_id"] = self.goodsID;
    param[@"num"] = self.numText.text;
    param[@"price"] = self.priceText.text;
    param[@"shop_name"] = self.shopText.text;
    param[@"contact_name"] = self.contectText.text;
    param[@"contact_mobile"] = self.telText.text;
    param[@"address"] = self.addressText.text;
    NSLog(@"%@", param);
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/DispatchGoods/dispatchGoods.html" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = responseObject[@"msg"];
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
        NSString *result = [NSString stringWithFormat:@"%@",  responseObject[@"status"]];
        if ([result isEqualToString:@"-1500"]) {
            //发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"申请调货刷新UI" object:self];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (IBAction)requestTiaoHuo:(id)sender {
    [self requestData];
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
