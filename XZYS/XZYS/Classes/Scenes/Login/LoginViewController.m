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

//NSString * const isLogin = @"Y";
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.phoneNum.text = [defaults objectForKey:@"userName"];
//    BOOL autoLogin = [defaults boolForKey:@"auto_login"];
//    NSLog(@"%@ -- %d", self.phoneNum.text, autoLogin);
    
    // Do any additional setup after loading the view from its nib.
}


// 登录
- (IBAction)loginButtonClick:(id)sender {
#warning 固定账号
    self.phoneNum.text = @"15046783721";
    self.passWord.text = @"15046783721";

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
            [defaults setBool:YES forKey:@"auto_login"];
            // 3.立刻同步
            [defaults synchronize];
            self.userId = dataDic[@"uid"];
        } else {
            NSLog(@"userId = nil");
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-106"]){
            hud.labelText = dic[@"msg"];
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.isLogin = @"Yes";
            appDelegate.userIdTag = self.userId;
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            
        } else {
            hud.labelText = dic[@"msg"];
        }
        NSLog(@"request:%@", dic[@"msg"]);
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 数据加载失败回调.
        NSLog(@"登录失败: %@",error);
    }];
}

// 注册
- (IBAction)regiestButtonClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    RegiestViewController *regiestVC = [[RegiestViewController alloc] init];
    [self.navigationController pushViewController:regiestVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    NSLog(@"wdfashdjfm");
}

// 忘记密码
- (IBAction)forgetPassWord:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    PassWordViewController *passWord = [[PassWordViewController alloc] init];
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
