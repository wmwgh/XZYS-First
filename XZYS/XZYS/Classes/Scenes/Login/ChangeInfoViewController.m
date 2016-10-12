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
#import "XZYS_Other.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AddressModel.h"
#import "PCTModel.h"

@interface ChangeInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
}
@property (nonatomic , strong) NSData *imageData;
@property (nonatomic , strong) NSMutableDictionary *params;
@property (nonatomic , strong) AddressModel *model;
@property (nonatomic,strong) UIPickerView * pickerView;//自定义pickerview
@property (nonatomic,strong) NSMutableArray *provinceArrar;
@property (nonatomic,strong) NSMutableArray *cityArrar;
@property (nonatomic,strong) NSMutableArray *sectionArrar;
@property (nonatomic,copy) NSString *cityID;
@property (nonatomic,copy) NSString *provinceID;
@property (nonatomic,copy) NSString *sectionID;
@property (nonatomic,copy) NSString *cityIDtText;
@property (nonatomic,copy) NSString *provinceIDText;
@property (nonatomic,copy) NSString *sectionIDText;
@property (nonatomic , strong) UIView *back;
@property (nonatomic , strong) UIView *mainBack;

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
    self.addressLabel.layer.borderWidth = 1;
    self.addressLabel.layer.cornerRadius = 5;
    self.addressLabel.layer.borderColor = XZYSRGBColor(231, 231, 231).CGColor;
    self.addressLabel.layer.masksToBounds = YES;

    self.title = @"修改资料";
    [self setIcornButton];
    //默认头像
    [_iconBtn setImage:[UIImage imageNamed:@"info_04"] forState:UIControlStateNormal];
    //获取需要展示的数据
    [self getAddressInformation];
    [self setPickerView];
    self.mainBack.hidden = YES;
}

- (void)dateEnsureAction {
//    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", self.provinceID, self.cityID, self.sectionID];
    self.sectionLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.provinceIDText, self.cityIDtText, self.sectionIDText];
    self.mainBack.hidden = YES;
}

- (void)dateCancleAction {
    self.mainBack.hidden = YES;
}


- (void)setPickerView {
    self.mainBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mainBack.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.7];
    [self.view addSubview:_mainBack];
    self.back = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 190, [UIScreen mainScreen].bounds.size.width, 190)];
    self.back.backgroundColor = [UIColor whiteColor];
    [self.mainBack addSubview:self.back];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    cancleBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancleBtn addTarget:self action:@selector(dateCancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.back addSubview:cancleBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [ensureBtn setTitle:@"确定" forState:0];
    ensureBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, 40);
    [ensureBtn addTarget:self action:@selector(dateEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.back addSubview:ensureBtn];
    
    // 初始化pickerView
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 150)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.back addSubview:self.pickerView];
    //指定数据源和委托
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)getAddressInformation {
    self.provinceArrar = [NSMutableArray array];
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaProvince" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *ar = responseObject[@"data"];
        for (NSDictionary *dic in ar) {
            PCTModel *model = [[PCTModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.provinceArrar addObject:model];
        }
        PCTModel *model = [[PCTModel alloc] init];
        model = self.provinceArrar[0];
        self.provinceID = model.area_id;
        [self requestCities];
        [self.pickerView reloadAllComponents];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

- (void)requestCities {
    self.cityArrar = [NSMutableArray array];
    [self.cityArrar removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"city_id"] = self.provinceID;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaCity/city_id/3" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *ar = responseObject[@"data"];
        for (NSDictionary *dic in ar) {
            PCTModel *model = [[PCTModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.cityArrar addObject:model];
        }
        PCTModel *model = [[PCTModel alloc] init];
        model = self.cityArrar[0];
        self.cityID = model.area_id;
        [self requestTowns];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView reloadComponent:1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

- (void)requestTowns {
    self.sectionArrar = [NSMutableArray array];
    [self.sectionArrar removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"district_id"] = self.cityID;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaDistrict/district_id/111" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *ar = responseObject[@"data"];
        for (NSDictionary *dic in ar) {
            PCTModel *model = [[PCTModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sectionArrar addObject:model];
        }
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        [self.pickerView reloadComponent:2];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.provinceArrar.count;//根据数组的元素个数返回几行数据
            break;
        case 1:
            result = self.cityArrar.count;
            break;
        case 2:
            result = self.sectionArrar.count;
            break;
        default:
            break;
    }
    return result;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title = nil;
    PCTModel *model1 = [[PCTModel alloc] init];
    PCTModel *model2 = [[PCTModel alloc] init];
    PCTModel *model3 = [[PCTModel alloc] init];
    switch (component) {
        case 0:
            model1 = self.provinceArrar[row];
            title = model1.area_name;
            self.provinceID = model1.area_id;
            self.provinceIDText = model1.area_name;
            break;
        case 1:
            model2 = self.cityArrar[row];
            title = model2.area_name;
            self.cityID = model2.area_id;
            self.cityIDtText = model2.area_name;
            break;
        case 2:
            model3 = self.sectionArrar[row];
            title = model3.area_name;
            self.sectionID = model3.area_id;
            self.sectionIDText = model3.area_name;
            break;
        default:
            break;
    }
    return title;
}

#pragma mark-设置下方的数据刷新
// 当选中了pickerView的某一行的时候调用
// 会将选中的列号和行号作为参数传入
// 只有通过手指选中某一行的时候才会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取对应列，对应行的数据
    //赋值
    if (0 == component) {
        PCTModel *model = [[PCTModel alloc] init];
        model = self.provinceArrar[row];
        self.provinceID = model.area_id;
        self.provinceIDText = model.area_name;
        [self requestCities];
    } else if (1 == component) {
        PCTModel *model = [[PCTModel alloc] init];
        model = self.cityArrar[row];
        self.cityID = model.area_id;
        self.cityIDtText = model.area_name;
        [self requestTowns];
    } else {
        PCTModel *model = [[PCTModel alloc] init];
        model = self.sectionArrar[row];
        self.sectionID = model.area_id;
        self.sectionIDText = model.area_name;
    }
}

- (IBAction)AddressPickerClick:(id)sender {
   self.mainBack.hidden = NO;
}



- (void)setDict {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.params[@"id"] = appDelegate.userIdTag;;
    if (self.params[@"id"] != nil && ![self.params[@"id"] isKindOfClass:[NSNull class]]) {
        [self setImg];
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
    self.params[@"area_province"] = self.provinceID;
    self.params[@"area_city"] = self.cityID;
    self.params[@"area_district"] = self.sectionID;
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


- (IBAction)outButtonClick:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/logout";
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 默认的方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appDelegate.userIdTag;
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
                appDelegate.isLogin = @"No";
                appDelegate.userIdTag = @"0";
                [self getNotofocation];
                UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
                loginVC.navigationBarHidden = YES;
                self.tabBarController.selectedIndex = 0;
                EMError *error = [[EMClient sharedClient] logout:YES];
                if (!error) {
                }
                [self.navigationController presentViewController:loginVC animated:NO completion:nil];
            } else {
                hud.labelText = dic[@"msg"];
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
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = blockSourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //相机
            blockSourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = blockSourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
    [_iconBtn setImage:image forState:UIControlStateNormal];

    self.imageData = UIImageJPEGRepresentation(image, 0.5);
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str1 = [formatter stringFromDate:[NSDate date]];
    NSString *str = [NSString stringWithFormat:@"header%@", str1];
    self.params[@"member_picture"] = str;
}

- (void)changeInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"http://www.xiezhongyunshang.com/App/User/memberInfoEdit";//放上传图片的网址
    [manager POST:url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件
        [formData appendPartWithFileData:self.imageData name:@"member_picture" fileName:@"image.jpg" mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 保存图片至本地沙盒

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    self.params[@"member_picture"] = fullPath;
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
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
