//
//  RequestShouHouController.m
//  XZYS
//
//  Created by 杨利 on 16/9/11.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "RequestShouHouController.h"
#import "XZYS_Other.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "BDImagePicker.h"
#import <MBProgressHUD.h>

@interface RequestShouHouController ()<NSCoding>
@property (nonatomic , copy) NSString *orderType;
@property (nonatomic , strong) NSData *img2Data;
@property (nonatomic , strong) NSData *img1Data;
@property (nonatomic , strong) NSData *img3Data;
@property (nonatomic , strong) NSMutableArray *imageDataArray;
@property (nonatomic , strong) NSMutableArray *imageNameArray;
@property (nonatomic , copy) NSString *img1Str;
@property (nonatomic , copy) NSString *img2Str;
@property (nonatomic , copy) NSString *img3Str;
@end

@implementation RequestShouHouController

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
    self.orderType = nil;
    self.title = @"申请售后";
    self.reaseonText.layer.cornerRadius = 5;
    self.reaseonText.layer.borderWidth = 1;
    self.reaseonText.layer.borderColor = XZYSRGBColor(231, 231, 231).CGColor;
//    NSLog(@"orderID::::%@", self.orderID);
//    NSLog(@"goodsID::::%@", self.goodsID);
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)tuihuoAction:(id)sender {
    self.tuihuoLab.textColor = XZYSBlueColor;
    self.huanhuoLab.textColor = [UIColor blackColor];
    self.weixiuLab.textColor = [UIColor blackColor];
    [self.tuihuoBt setImage:[UIImage imageNamed:@"gw_07.png"] forState:UIControlStateNormal];
    [self.huanhuoBt setImage:[UIImage imageNamed:@"gw_10.png"] forState:UIControlStateNormal];
    [self.weixiuBt setImage:[UIImage imageNamed:@"gw_10.png"] forState:UIControlStateNormal];
    self.orderType = @"1";
}
- (IBAction)huanhuoAction:(id)sender {
    self.tuihuoLab.textColor = [UIColor blackColor];
    self.huanhuoLab.textColor = XZYSBlueColor;
    self.weixiuLab.textColor = [UIColor blackColor];
    [self.huanhuoBt setImage:[UIImage imageNamed:@"gw_07.png"] forState:UIControlStateNormal];
    [self.tuihuoBt setImage:[UIImage imageNamed:@"gw_10.png"] forState:UIControlStateNormal];
    [self.weixiuBt setImage:[UIImage imageNamed:@"gw_10.png"] forState:UIControlStateNormal];
    self.orderType = @"2";
}
- (IBAction)weixiuAction:(id)sender {
    self.tuihuoLab.textColor = [UIColor blackColor];
    self.huanhuoLab.textColor = [UIColor blackColor];
    self.weixiuLab.textColor = XZYSBlueColor;
    [self.huanhuoBt setImage:[UIImage imageNamed:@"gw_10.png"] forState:UIControlStateNormal];
    [self.tuihuoBt setImage:[UIImage imageNamed:@"gw_10.png"] forState:UIControlStateNormal];
    [self.weixiuBt setImage:[UIImage imageNamed:@"gw_07.png"] forState:UIControlStateNormal];
    self.orderType = @"3";
}

- (IBAction)tijiaoAction:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 注册调用的网址
    NSString *urlString = @"http://www.xiezhongyunshang.com/App/CustomerService/customerService.html";
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"order_id"] = self.orderID;
    params[@"order_goods_id"] = self.goodsID;
    params[@"type"] = self.orderType;
    params[@"num"] = self.numText.text;
    params[@"reason"] = self.reaseonText.text;
    params[@"voucher_img1"] = self.img1Str;
    params[@"voucher_img2"] = self.img2Str;
    params[@"voucher_img3"] = self.img3Str;
    
    if (self.img1Str != nil || self.img2Str != nil || self.img3Str != nil) {
        [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            for (int i = 0; i < self.imageDataArray.count; i++) {
                NSData *imageData = self.imageDataArray[i];
                NSString *name = self.imageNameArray[i];
                [formData appendPartWithFileData:imageData name:name fileName:@"image.jpg" mimeType:@"image/jpg"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
//            NSLog(@"%@", responseObject);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if ([result isEqualToString:@"-1600"]) {
                hud.labelText = responseObject[@"msg"];
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)btn1:(id)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.img1.image) {
            if (image) {
                self.img1.image = image;
                self.img1Data = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str1 = [formatter stringFromDate:[NSDate date]];
                NSString *str = [NSString stringWithFormat:@"img1-%@", str1];
                self.img1Str = str;
                [self.imageNameArray addObject:@"voucher_img1"];
                [self.imageDataArray addObject:self.img1Data];
            }
        }
    }];
}

- (IBAction)btn2:(id)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.img2.image) {
            if (image) {
                self.img2.image = image;
                self.img2Data = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str1 = [formatter stringFromDate:[NSDate date]];
                NSString *str = [NSString stringWithFormat:@"img2-%@", str1];
                self.img2Str = str;
                [self.imageNameArray addObject:@"voucher_img2"];
                [self.imageDataArray addObject:self.img2Data];
            }
        }
    }];
}
- (IBAction)btn3:(id)sender {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (self.img3.image) {
            if (image) {
                self.img3.image = image;
                self.img3Data = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str1 = [formatter stringFromDate:[NSDate date]];
                NSString *str = [NSString stringWithFormat:@"img3-%@", str1];
                self.img3Str = str;
                [self.imageNameArray addObject:@"voucher_img3"];
                [self.imageDataArray addObject:self.img3Data];
            }
        }
    }];
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
