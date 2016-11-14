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
#import "EMSDK.h"
#import "UserProViewController.h"

@interface RegiestViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic , strong) RegiestView *regiestView;
@property (nonatomic , strong) NSMutableDictionary *dataParams;
@property (nonatomic , strong) NSData *zzImgData;
@property (nonatomic , strong) NSData *sfzbImgData;
@property (nonatomic , strong) NSData *sfzaImgData;
@property (nonatomic , strong) NSMutableArray *imageDataArray;
@property (nonatomic , strong) NSMutableArray *imageNameArray;

@property (nonatomic , copy) NSString *zzStr;
@property (nonatomic , copy) NSString *sfzbStr;
@property (nonatomic , copy) NSString *sfzaStr;
@end

@implementation RegiestViewController

- (NSMutableDictionary *)dataParams {
    if (!_dataParams) {
        _dataParams = [NSMutableDictionary dictionary];
    }
    return _dataParams;
}

- (NSMutableArray *)imageDataArray {
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
}

- (NSMutableArray *)imageNameArray {
    if (!_imageNameArray) {
        _imageNameArray = [NSMutableArray array];
    }
    return _imageNameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册中心";
    // Do any additional setup after loading the view from its nib.
    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.contentSize = CGSizeMake(SCREEN_WIDTH, 660);
    backView.delegate = self;
    backView.showsHorizontalScrollIndicator = NO;
    backView.pagingEnabled = NO;
    backView.bounces = NO;
    [self.view addSubview:backView];
    self.regiestView = [RegiestView loadFromNib];
    self.regiestView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 660);
    [backView addSubview:self.regiestView];
    
    
    // 判断密码
    [self.regiestView.passWord addTarget:self action:@selector(checkPasswordAction) forControlEvents:UIControlEventEditingDidEnd];
    [self.regiestView.passWordAgain addTarget:self action:@selector(checkAgainPasswordAction) forControlEvents:UIControlEventEditingDidEnd];
    
    // 判断手机号
    [self.regiestView.phoneNum addTarget:self action:@selector(checkPhone) forControlEvents:UIControlEventEditingDidEnd];
    
    // 验证按钮
    [self.regiestView.yanZhengMaButton addTarget:self action:@selector(yanzhengClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 注册按钮
    [self.regiestView.regiestButton addTarget:self action:@selector(registeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 使用条款
    [self.regiestView.useProBtn addTarget:self action:@selector(useProBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTap];
}

- (void)useProBtnAction {
    UserProViewController *userVC= [[UserProViewController alloc] init];
    userVC.titName = @"协议和条款";
    userVC.urlType = @"http://xzyspt.com/Home/Index/page/id/87/cate/platform_profile/cid/2.html";
    [self.navigationController pushViewController:userVC animated:YES];
}
#pragma mark --- 手势设置

- (void)setTap {
    //设置搜索单击手势
    [self.regiestView.zhizhaoImg setUserInteractionEnabled:YES];
    [self.regiestView.zhizhaoImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhengjianImg:)]];
    [self.regiestView.sfzImgBefore setUserInteractionEnabled:YES];
    [self.regiestView.sfzImgBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sfzBeforeImg:)]];
    [self.regiestView.sfzImgAfter setUserInteractionEnabled:YES];
    [self.regiestView.sfzImgAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sfzAfterImg:)]];
    
}

- (void)zhengjianImg:(UIButton *)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.regiestView.zhizhaoImg.image) {
            if (image) {
                self.regiestView.zhizhaoImg.image = image;
                self.zzImgData = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str1 = [formatter stringFromDate:[NSDate date]];
                NSString *str = [NSString stringWithFormat:@"zz-%@", str1];
                self.zzStr = str;
                [self.imageDataArray addObject:self.zzImgData];
                [self.imageNameArray addObject:@"business_img"];
            }
        }
    }];
}
- (void)sfzBeforeImg:(UIButton *)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.regiestView.sfzImgBefore.image) {
            if (image) {
                self.regiestView.sfzImgBefore.image = image;
                self.sfzbImgData = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str1 = [formatter stringFromDate:[NSDate date]];
                NSString *str = [NSString stringWithFormat:@"sfzb-%@", str1];
                self.sfzbStr = str;
                [self.imageDataArray addObject:self.sfzbImgData];
                [self.imageNameArray addObject:@"legal_img_a"];
            }
        }
    }];
}
- (void)sfzAfterImg:(UIButton *)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.regiestView.sfzImgAfter.image) {
            if (image) {
                self.regiestView.sfzImgAfter.image = image;
                self.sfzaImgData = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str1 = [formatter stringFromDate:[NSDate date]];
                NSString *str = [NSString stringWithFormat:@"sfza-%@", str1];
                self.sfzaStr = str;
                [self.imageDataArray addObject:self.sfzaImgData];
                [self.imageNameArray addObject:@"legal_img_b"];
            }
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
        [hud hide:YES afterDelay:1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败的原因可能有多种，常见的是用户名已经存在。
//        NSLog(@"发送验证失败 %@", error);
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
        [hud hide:YES afterDelay:1];

    } else if (self.regiestView.passWord.text.length < 6){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入不少于6位的密码";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1];
    } else if (![self.regiestView.passWordAgain.text isEqualToString:self.regiestView.passWord.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不一致,请重新输入";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1];
    } else if ([self.regiestView.farenName.text isKindOfClass:[NSNull class]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入真实的法人姓名";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1];
    } else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 注册调用的网址
        NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/registe";
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.dataParams[@"username"] = self.regiestView.phoneNum.text;
        self.dataParams[@"password"] = self.regiestView.passWord.text;
        self.dataParams[@"repassword"] = self.regiestView.passWordAgain.text;
        self.dataParams[@"verify"] = self.regiestView.yanZhengMa.text;
        self.dataParams[@"legal_name"] = self.regiestView.farenName.text;
        self.dataParams[@"business_img"] = self.zzStr;
        self.dataParams[@"legal_img_a"] = self.sfzbStr;
        self.dataParams[@"legal_img_b"] = self.sfzaStr;
        
        if (self.zzStr != nil && self.sfzbStr != nil && self.sfzaStr != nil) {
            [manager POST:urlString parameters:self.dataParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                // 上传文件
                // 上传 多张图片
                for(NSInteger i = 0; i < self.imageDataArray.count; i++)
                {
                    NSData *imageData = [self.imageDataArray objectAtIndex: i];
                    // 上传的参数名
                    NSString *name = [NSString stringWithFormat:@"%@", self.imageNameArray[i]];
                    
                    [formData appendPartWithFileData:imageData name:name fileName:@"image.jpg" mimeType:@"image/jpg"];
                }
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *result = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                if ([result isEqualToString:@"-526"]) {
                    hud.labelText = responseObject[@"msg"];
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
#pragma mark -- 环信注册
//                    NSString *loginId = [NSString stringWithFormat:@"hx%@xzys", self.regiestView.phoneNum.text];
//                    NSString *loginWord = @"xzyspassword";
//                    EMError *error = [[EMClient sharedClient] registerWithUsername:loginId password:loginWord];
//                    if (!error) {
//                        NSLog(@"huanxin注册成功");
                        
//                    } else {
//                        NSLog(@"huanxin注册失败 %d  %@", error.code, error.description);
//                    }
                    //注册成功后调用
                    [self registerSuccess];
                } else {
                    hud.labelText = responseObject[@"msg"];
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            }];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请完善信息";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
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
    [hud hide:YES afterDelay:1];

    
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
//        NSLog(@"%@", dic);
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        NSDictionary *dataDic = dic[@"data"];
        if (![dataDic isEqual:@""]) {
            // 1.利用NSUserDefaults,就能直接访问软件的偏好设置(Library/Preferences)
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            // 2.存储数据
            [defaults setObject:self.regiestView.phoneNum.text forKey:@"userName"];
            [defaults setObject:self.regiestView.passWord.text forKey:@"passWord"];
            // 3.立刻同步
            [defaults synchronize];
            self.userId = dataDic[@"uid"];
        } else {
//            NSLog(@"userId = nil");
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
//        NSLog(@"request:%@", dic[@"msg"]);
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 数据加载失败回调.
//        NSLog(@"登录失败: %@",error);
    }];
}

// 判断手机号
- (void)checkPhone {
    
    if (![YHRegular checkTelNumber:self.regiestView.phoneNum.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号码";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
}
// 判断密码
- (void)checkPasswordAction {
    
    if (self.regiestView.passWord.text.length < 6 || self.regiestView.passWord.text.length > 30) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码必须是6-30位的字母加数字";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
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
        [hud hide:YES afterDelay:1];
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
