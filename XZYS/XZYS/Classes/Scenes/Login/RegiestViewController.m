//
//  RegiestViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "RegiestViewController.h"
#import "RegiestView.h"
#import "UIView+LoadFromNib.h"
#import "XZYS_Other.h"
#import "YHRegular.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "BDImagePicker.h"


@interface RegiestViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic , strong) RegiestView *regiestView;

@end

@implementation RegiestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册中心";
    // Do any additional setup after loading the view from its nib.
    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.contentSize = CGSizeMake(SCREEN_WIDTH, 630);
    backView.delegate = self;
    backView.showsHorizontalScrollIndicator = NO;
    backView.pagingEnabled = NO;
    backView.bounces = NO;
    [self.view addSubview:backView];
    self.regiestView = [RegiestView loadFromNib];
    self.regiestView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 630);
    [backView addSubview:self.regiestView];
    
    
    // 判断密码
    [self.regiestView.passWord addTarget:self action:@selector(checkPasswordAction) forControlEvents:UIControlEventEditingDidEnd];
    [self.regiestView.passWordAgain addTarget:self action:@selector(checkAgainPasswordAction) forControlEvents:UIControlEventEditingDidEnd];
    
    // 判断手机号
    [self.regiestView.phoneNum addTarget:self action:@selector(checkPhone) forControlEvents:UIControlEventEditingDidEnd];
    
    // 上传照片
    [self.regiestView.zhizhao addTarget:self action:@selector(zhengjianImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.regiestView.sfzBefore addTarget:self action:@selector(sfzBeforeImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.regiestView.sfzAfter addTarget:self action:@selector(sfzAfterImg:) forControlEvents:UIControlEventTouchUpInside];
    
    // 验证按钮
    [self.regiestView.yanZhengMaButton addTarget:self action:@selector(yanzhengClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 注册按钮
    [self.regiestView.regiestButton addTarget:self action:@selector(registeBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)zhengjianImg:(UIButton *)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.regiestView.zhizhao) {
            [sender setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
}

- (void)sfzBeforeImg:(UIButton *)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.regiestView.sfzBefore) {
            [sender setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
}
- (void)sfzAfterImg:(UIButton *)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.regiestView.sfzAfter) {
            [sender setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
}


- (void)yanzhengClick {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/sendRegVerify";
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 默认的方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    int a = [self.regiestView.phoneNum.text intValue];
//    NSLog(@"%@", self.regiestView.phoneNum.text);
//    NSLog(@"%d", a);
//    [params setObject:[NSNumber numberWithInt:a] forKey:@"username"];
    [params setObject:self.regiestView.phoneNum.text forKey:@"username"];
    NSLog(@"%@", params);
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
        } else {
            hud.labelText = @"验证码发送成功";
        };
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败的原因可能有多种，常见的是用户名已经存在。
        NSLog(@"发送验证失败 %@", error);
    }];
}

//  注册按钮方法
- (void)registeBtnAction {
    
    if (![YHRegular checkTelNumber:self.regiestView.phoneNum.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"手机号码格式有误,请重新填写";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];

    } else if (self.regiestView.passWord.text.length < 6){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入不少于6位的密码";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    } else if (![self.regiestView.passWordAgain.text isEqualToString:self.regiestView.passWord.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不一致,请重新输入";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    } else if ([self.regiestView.farenName.text isKindOfClass:[NSNull class]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入真实的法人姓名";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    } else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
#warning 请输入注册调用的网址
        // 注册调用的网址
        NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/registe";
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 默认的方式
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"username"] = self.regiestView.phoneNum.text;
        params[@"password"] = self.regiestView.passWord.text;
        params[@"repassword"] = self.regiestView.passWordAgain.text;
        params[@"verify"] = self.regiestView.yanZhengMa.text;
        params[@"legal_name"] = self.regiestView.farenName.text;
//        parms[@"legal_img_a"] = self.regiestView.passWord.text;
//        parms[@"legal_img_b"] = self.regiestView.passWordAgain.text;
//        parms[@"business_img"] = self.regiestView.yanZhengMa.text;

        [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 数据加载完后回调.
            NSError *error;
            NSString *result1 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            NSData *data = [result1 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if ([result isEqualToString:@"-526"]) {
                hud.labelText = dic[@"msg"];
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.5];
                //注册成功后调用
                [self registerSuccess];
            } else {
                hud.labelText = dic[@"msg"];
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.5];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //数据加载失败回调.
            NSLog(@"注册失败: %@",error);
        }];
    }
}


// 注册成功 登录
-(void)registerSuccess{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"注册成功!";
    hud.detailsLabelText = @"正在为您登录...";
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:4];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    
    
    // 参数 phone手机号码 password密码
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/login";
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 默认的方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = self.regiestView.phoneNum.text;
    params[@"password"] = self.regiestView.passWord.text;
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSError *error;
        NSString *result1 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        NSData *data = [result1 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-106"]){
            hud.labelText = dic[@"msg"];
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.isLogin = @"Yes";
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            hud.labelText = dic[@"msg"];
        }
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 数据加载失败回调.
        NSLog(@"登录失败: %@",error);
    }];
}

#warning  数据持久化
-(void)delayMethod{
    NSDictionary *resultDiction = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"loginState", nil];
    [[NSUserDefaults standardUserDefaults] setObject:resultDiction forKey:@"ResultAuthData"];
    //保存数据，实现持久化存储
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 判断手机号
- (void)checkPhone {
    
    if (![YHRegular checkTelNumber:self.regiestView.phoneNum.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号码";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}
// 判断密码
- (void)checkPasswordAction {
    
    if (self.regiestView.passWord.text.length < 6 || self.regiestView.passWord.text.length > 30) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码必须是6-30位的字母加数字";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }
}
- (void)checkAgainPasswordAction {
    NSString *passWord = [NSString stringWithFormat:@"%@", self.regiestView.passWord.text];
    NSString *passWordAgain = [NSString stringWithFormat:@"%@", self.regiestView.passWordAgain.text];
    
    if (![passWordAgain isEqualToString:passWord]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不一致,请重新输入";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
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
