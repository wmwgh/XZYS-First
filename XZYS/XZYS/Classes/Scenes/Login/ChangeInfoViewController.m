//
//  ChangeInfoViewController.m
//  XZYS
//
//  Created by 杨利 on 16/9/1.
//  Copyright © 2016年 吴明伟. All rights reserved.
//
#define Key_DistrictSelectProvince          @"DistrictSelectProvince"
#define Key_DistrictSelectProvinceCode      @"DistrictSelectProvinceCode"
#define Key_DistrictSelectProvinceSubCode   @"DistrictSelectProvinceSubCode"
#define Key_DistrictSelectProvinceSub       @"DistrictSelectProvinceSub"
#define Key_DistrictSelectCityCode          @"DistrictSelectCityCode"
#define Key_DistrictSelectCity              @"DistrictSelectCity"

#import "ChangeInfoViewController.h"
#import "BDImagePicker.h"
#import <MBProgressHUD.h>
#import "YHRegular.h"
#import "GPDateView.h"
#import "XZYS_Other.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface ChangeInfoViewController ()
@property (nonatomic , strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSArray *ProvinceArray;
@property (nonatomic, strong) NSArray *CityArray;
@property (nonatomic, strong) NSArray *districtArray;
@property (nonatomic , strong) GPDateView *gpDateView;

@end

@implementation ChangeInfoViewController

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ProvinceArray = [NSMutableArray array];
    self.CityArray = [NSMutableArray array];
    self.districtArray = [NSMutableArray array];
//    [self requsetAddress];
    self.title = @"修改资料";
    self.addressLabel.layer.cornerRadius = 5;
    self.addressLabel.layer.borderColor = XZYSRGBColor(231, 231, 231).CGColor;
    self.addressLabel.layer.borderWidth = 1;
    self.addressLabel.layer.masksToBounds = YES;
    [self setIcornButton];
    //默认头像
    [_iconBtn setImage:[UIImage imageNamed:@"info_04"] forState:UIControlStateNormal];
}
//- (void)requsetAddress {
//    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaProvince" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        self.ProvinceArray = responseObject[@"data"];
////        self.gpDateView.ProvinceArray = self.ProvinceArray;
//        NSLog(@"%@", self.ProvinceArray);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    }];
//    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaCity/city_id/3" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        self.CityArray = responseObject[@"data"];
////        self.gpDateView.CityArray = self.CityArray;
//        NSLog(@"%@", self.CityArray);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    }];
//    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaDistrict/district_id/111" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        self.districtArray = responseObject[@"data"];
////        self.gpDateView.districtArray = self.districtArray;
//        NSLog(@"%@", self.districtArray);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    }];
//}

- (IBAction)AddressPickerClick:(id)sender {
    GPDateView * dateView = [[GPDateView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250) Data:nil];
    
    [dateView showPickerView];
    
    dateView.ActionDistrictViewSelectBlock = ^(NSString *desStr,NSDictionary *selectDistrictDict){
        
        NSString *str1 = [selectDistrictDict objectForKey:Key_DistrictSelectProvince];
        NSString *str2 = [selectDistrictDict objectForKey:Key_DistrictSelectCity];
        NSString *str3 = [selectDistrictDict objectForKey:Key_DistrictSelectProvinceSub];
        // 省
        self.params[@"area_province"] = str1;
        // 市
        self.params[@"area_city"] = str2;
        // 县
        self.params[@"area_district"] = str3;
        self.sectionLabel.text = [NSString stringWithFormat:@"%@ %@ %@", str1, str2, str3];
    };
}

- (void)setDict {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.params[@"id"] = appDelegate.userIdTag;;
    if (self.params[@"id"] != nil && ![self.params[@"id"] isKindOfClass:[NSNull class]]) {
        [self setImg];
    } else {
        NSLog(@"UID没有啊");
    }
}
- (void)setImg {
    if (self.params[@"member_picture"] != nil && ![self.params[@"member_picture"] isKindOfClass:[NSNull class]]) {
        [self setName];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请重新上传头像";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    }
}
- (void)setName {
    self.params[@"nickname"] = self.nameLabel.text;
    if (self.params[@"nickname"] != nil && ![self.params[@"nickname"] isKindOfClass:[NSNull class]] && ![self.params[@"nickname"] isEqualToString:@""]) {
        [self setSex];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入用户名";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    }
}

- (void)setSex {
    if (self.params[@"sex"] != nil && ![self.params[@"sex"] isKindOfClass:[NSNull class]]) {
        [self setEmail];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请选择性别";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    }
}


- (void)setEmail {
    self.params[@"email"] = self.emailLabel.text;
    if ([YHRegular checkEmail:self.emailLabel.text]) {
        [self setSection];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的邮箱地址";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    }
}
- (void)setSection {
    if (self.params[@"area_district"] != nil && ![self.params[@"area_district"] isKindOfClass:[NSNull class]]) {
        [self setAddresss];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的地区";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    }
}

- (void)setAddresss {
    self.params[@"shop_address"] = self.addressLabel.text;
    if (self.params[@"shop_address"] != nil && ![self.params[@"shop_address"] isKindOfClass:[NSNull class]] && ![self.params[@"shop_address"] isEqualToString:@""]) {
        NSLog(@"%@", _params);
        NSLog(@"成功了");
        [self changeInfo];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入店铺的详细地址";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    }
}

- (IBAction)sureButtonClick:(id)sender {
    
    [self setDict];
    
}


- (void)changeInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/memberInfoEdit";
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 默认的方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:_params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSError *error;
        NSString *result1 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        NSData *data = [result1 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = dic[@"msg"];
        NSLog(@"修改成功 success");
        [self.navigationController popViewControllerAnimated:NO];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (IBAction)outButtonClick:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/logout";
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 默认的方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appDelegate.userIdTag;
    NSLog(@"%@", params);
    if (!params) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您还没有登录";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } else {
        [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 数据加载完后回调.
            NSError *error;
            NSString *result1 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            NSData *data = [result1 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if([result isEqualToString:@"-107"]){
                hud.labelText = dic[@"msg"];
                NSLog(@"out----success");
                appDelegate.isLogin = @"No";
                appDelegate.userIdTag = @"0";
                [self getNotofocation];
                UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
                loginVC.navigationBarHidden = YES;
                self.tabBarController.selectedIndex = 0;
                
                [self.navigationController presentViewController:loginVC animated:NO completion:nil];
            } else {
                hud.labelText = dic[@"msg"];
                NSLog(@"faile");
            }
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}

- (void)getNotofocation{
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"退出登录刷新UI" object:self];
}

- (IBAction)manClick:(id)sender {
    [self.params removeObjectForKey:@"sex"];
    self.params[@"sex"] = @"1";
    [self.manButton setImage:[UIImage imageNamed:@"gw_07"] forState:UIControlStateNormal];
    [self.nvButton setImage:[UIImage imageNamed:@"gw_10"] forState:UIControlStateNormal];
}
- (IBAction)nvClick:(id)sender {
    [self.params removeObjectForKey:@"sex"];
    self.params[@"sex"] = @"2";
    [self.manButton setImage:[UIImage imageNamed:@"gw_10"] forState:UIControlStateNormal];
    [self.nvButton setImage:[UIImage imageNamed:@"gw_07"] forState:UIControlStateNormal];
}

- (void)setIcornButton {
    //初始化Button
    _iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(SW / 2 - 35, 70, 70, 70)];
//    //加载首先访问本地沙盒是否存在相关图片
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"headerImage.png"];
//    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
//    if (!savedImage)
//    {
//        //默认头像
//        [_iconBtn setImage:[UIImage imageNamed:@"info_04"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_iconBtn setImage:savedImage forState:UIControlStateNormal];
//    }
    _iconBtn.layer.masksToBounds = YES;
    _iconBtn.layer.cornerRadius = _iconBtn.frame.size.height / 2;
    [_iconBtn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_iconBtn];
}


- (void)changeIcon
{
    UIAlertController *alertController;
    
    __block NSUInteger blockSourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //支持访问相机与相册情况
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = blockSourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击拍照");
            //相机
            blockSourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = blockSourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        //只支持访问相册情况
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = blockSourceType;
            [self presentViewController:imagePickerController animated:YES completion:^{
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - 选择图片后,回调选择

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    /* 此处info 有六个可选类型
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    [_iconBtn setImage:image forState:UIControlStateNormal];
    [self setInfoImg:image];
}

#pragma mark - 保存图片至本地沙盒

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.8);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    self.params[@"member_picture"] = fullPath;
    NSLog(@"%@", self.params);
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#warning tyui++++++++++++++++++

- (void)setInfoImg:(UIImage *)image {
    NSString *strin = [NSString string];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    strin = [NSString stringWithFormat:@"/Uploads/MemberPicture/%@/%@", dateString, fileName];
    NSLog(@"%@", strin);
    
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
