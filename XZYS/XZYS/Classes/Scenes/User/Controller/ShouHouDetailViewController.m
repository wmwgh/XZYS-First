//
//  ShouHouDetailViewController.m
//  XZYS
//
//  Created by 杨利 on 16/10/5.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShouHouDetailViewController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "ShouHouModel.h"
#import <UIImageView+WebCache.h>

@interface ShouHouDetailViewController ()
@property (nonatomic ,strong) NSMutableArray *allDataArray;
@property (nonatomic , copy) NSString *receiveOrder;
@end

@implementation ShouHouDetailViewController
- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后详情";
    [self requestAllData];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)sureButton:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"order_id"] = self.receiveOrder;
    params[@"act"] = @"shipping_complete";
    
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Order/orderOperationReception.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *order = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([order isEqualToString:@"-101"]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
        }
        NSLog(@"shouhoudingdan");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _allDataArray = [NSMutableArray array];
    [_allDataArray removeAllObjects];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"id"] = self.orderID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/CustomerService/customerServiceDetails.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *order = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([order isEqualToString:@"-101"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            ShouHouModel *model = [[ShouHouModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [weakSelf.allDataArray addObject:model];
        
            [self setValue];
            // 隐藏指示器
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)setValue {
    ShouHouModel *model = [[ShouHouModel alloc] init];
    model = self.allDataArray[0];
    self.shopName.text = model.shop_name;
    self.shouHouOrder.text = model.type_text;
    self.colorLab.text = model.goods_color;
    self.sizeLab.text = model.goods_size;
    self.numLab.text = [NSString stringWithFormat:@"X%@", model.num];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.jinduLab.text = model.status_text;
    float a = [model.price floatValue];
    int b = [model.num floatValue];
    float c = a * b;
    NSString *str = [NSString stringWithFormat:@"%.2f", c];
    self.hejiLab.text = str;
    self.heji1.text = str;
    self.reasonLab.text = model.reason;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.goods_img]]];
    self.goodsName.text = model.goods_name;
    id arr = model.voucher_img;
    self.receiveOrder = model.order_id;
    if ([arr isKindOfClass:[NSArray class]]) {
        NSArray *ar = arr;
        if (ar.count > 0) {
            
            for (int i = 0; i < ar.count; i++) {
                NSString *strin = ar[i];
                if (i == 0) {
                    [self.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, strin]]];
                } else if (i == 1) {
                    [self.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, strin]]];
                } else if (i == 2) {
                    [self.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, strin]]];
                }
            }
    }
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAllData];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
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
