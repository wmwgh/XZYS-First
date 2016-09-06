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

@interface ChangeInfoViewController ()
@property (nonatomic , strong) NSMutableDictionary *params;
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
    self.title = @"修改资料";
    self.addressLabel.layer.cornerRadius = 5;
    self.addressLabel.layer.borderColor = XZYSRGBColor(231, 231, 231).CGColor;
    self.addressLabel.layer.borderWidth = 1;
    self.addressLabel.layer.masksToBounds = YES;
    [self setIcornButton];
    // Do any additional setup after loading the view from its nib.
    
}

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
    self.params[@"id"] = @"1";
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
    //加载首先访问本地沙盒是否存在相关图片
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
    if (!savedImage)
    {
        //默认头像
        [_iconBtn setImage:[UIImage imageNamed:@"info_04"] forState:UIControlStateNormal];
    }
    else
    {
        [_iconBtn setImage:savedImage forState:UIControlStateNormal];
    }
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
    [self saveImage:image withName:@"currentImage.png"];
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
