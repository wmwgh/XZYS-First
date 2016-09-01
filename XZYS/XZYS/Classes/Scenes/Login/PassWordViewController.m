//
//  PassWordViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "PassWordViewController.h"
#import <MBProgressHUD.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "YHRegular.h"

@interface PassWordViewController ()

@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    // 判断密码
    [self.passWord addTarget:self action:@selector(checkPasswordAction) forControlEvents:UIControlEventEditingDidEnd];
    [self.passWordAgain addTarget:self action:@selector(checkAgainPasswordAction) forControlEvents:UIControlEventEditingDidEnd];
    // 判断手机号
    [self.phoneNum addTarget:self action:@selector(checkPhone) forControlEvents:UIControlEventEditingDidEnd];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData {
    if (![YHRegular checkTelNumber:self.phoneNum.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"手机号码格式有误,请重新填写";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
        
    } else if (self.yanZhengMa.text.length != 6){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"验证码不正确";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    } else if (self.passWord.text.length < 6){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入不少于6位的密码";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    } else if (![self.passWordAgain.text isEqualToString:self.passWord.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不一致,请重新输入";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    } else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/resetPassword";
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 默认的方式
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"verify"] = self.yanZhengMa.text;
        params[@"username"] = self.phoneNum.text;
        params[@"password"] = self.passWord.text;
        params[@"repassword"] = self.passWordAgain.text;
        [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 数据加载完后回调.
            NSError *error;
            NSString *result1 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            NSData *data = [result1 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if([result isEqualToString:@"-108"]){
                hud.labelText = dic[@"msg"];
                NSLog(@"success");
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                hud.labelText = dic[@"msg"];
                NSLog(@"faile");
            }
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 数据加载失败回调.
            NSLog(@"登录失败: %@",error);
        }];
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
- (IBAction)yanzhengmaClick:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/sendResVerify";
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 默认的方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    int a = [self.regiestView.phoneNum.text intValue];
    //    NSLog(@"%@", self.regiestView.phoneNum.text);
    //    NSLog(@"%d", a);
    //    [params setObject:[NSNumber numberWithInt:a] forKey:@"username"];
    [params setObject:self.phoneNum.text forKey:@"username"];
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调
        NSError *error;
        NSString *result1 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        NSData *data = [result1 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-501"]){
            hud.labelText = dic[@"msg"];
        } else if([result isEqualToString:@"-717"]){
            hud.labelText = dic[@"msg"];
        };
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败的原因可能有多种，常见的是用户名已经存在。
        NSLog(@"发送验证失败 %@", error);
    }];
}
- (IBAction)changeClick:(id)sender {
    [self requestData];
    
}

// 判断手机号
- (void)checkPhone {
    
    if (![YHRegular checkTelNumber:self.phoneNum.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号码";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}
// 判断密码
- (void)checkPasswordAction {
    
    if (self.passWord.text.length < 6 || self.passWord.text.length > 30) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码必须是6-30位的字符加数字";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }
}

- (void)checkAgainPasswordAction {
    NSString *passWord = [NSString stringWithFormat:@"%@", self.passWord.text];
    NSString *passWordAgain = [NSString stringWithFormat:@"%@", self.passWordAgain.text];
    
    if (![passWordAgain isEqualToString:passWord]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不一致,请重新输入";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }
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
