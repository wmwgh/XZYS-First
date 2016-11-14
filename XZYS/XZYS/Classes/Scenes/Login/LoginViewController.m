//
//  LoginViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "LoginViewController.h"
#import "RegiestViewController.h"
#import "PassWordViewController.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "EMSDK.h"
#import "EaseUI.h"

//NSString * const isLogin = @"Y";
@interface LoginViewController ()<EMContactManagerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passWord.secureTextEntry = YES;
    self.title = @"登录";
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.phoneNum.text = [defaults objectForKey:@"userName"];

    
    // Do any additional setup after loading the view from its nib.
}


// 登录
- (IBAction)loginButtonClick:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/login";
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 默认的方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = self.phoneNum.text;
    params[@"password"] = self.passWord.text;
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSError *error;
        NSString *result1 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        NSData *data = [result1 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        NSDictionary *dataDic = dic[@"data"];
        if (![dataDic isEqual:@""]) {
            // 1.利用NSUserDefaults,就能直接访问软件的偏好设置(Library/Preferences)
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            // 2.存储数据
            [defaults setObject:self.phoneNum.text forKey:@"userName"];
            [defaults setObject:self.passWord.text forKey:@"passWord"];
            // 3.立刻同步
            [defaults synchronize];
#warning 删除保存的用户名
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passWord"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.userId = dataDic[@"uid"];
        } else {
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-106"]){
            hud.labelText = dic[@"msg"];
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.isLogin = @"Yes";
            appDelegate.userIdTag = self.userId;
#pragma mark -- 环信登录
            NSString *loginId = [NSString stringWithFormat:@"hx%@xzys", self.phoneNum.text];
            NSString *loginWord = @"xzyspassword";
            EMError *error = [[EMClient sharedClient] loginWithUsername:loginId password:loginWord];
//            if (!error) {
//            } else {
//                
//#pragma mark -- 环信注册
//                NSString *loginId = [NSString stringWithFormat:@"hx%@xzys", self.phoneNum.text];
//                NSString *loginWord = @"xzyspassword";
//                EMError *error = [[EMClient sharedClient] registerWithUsername:loginId password:loginWord];
//                if (!error) {
//                    EMError *error = [[EMClient sharedClient] loginWithUsername:loginId password:loginWord];
//                    if (!error) {
//                    } else {
//                    }
//                } else {
//                }
//            }
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        } else {
            hud.labelText = dic[@"msg"];
        }
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 数据加载失败回调.
    }];
}

// 注册
- (IBAction)regiestButtonClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    RegiestViewController *regiestVC = [[RegiestViewController alloc] init];
    [self.navigationController pushViewController:regiestVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

// 忘记密码
- (IBAction)forgetPassWord:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    PassWordViewController *passWord = [[PassWordViewController alloc] init];
    passWord.orderTypeId = @"1";
    [self.navigationController pushViewController:passWord animated:YES];
    self.hidesBottomBarWhenPushed = YES;
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
