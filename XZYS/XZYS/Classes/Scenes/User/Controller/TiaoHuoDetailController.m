//
//  TiaoHuoDetailController.m
//  XZYS
//
//  Created by 杨利 on 16/9/12.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "TiaoHuoDetailController.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>
#import "XZYS_Other.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>


@interface TiaoHuoDetailController ()
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

@implementation TiaoHuoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调货详情";
    // Do any additional setup after loading the view from its nib.
    [self setModel];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
}


- (void)setModel {
    self.dataArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.model = [[TiaoHuoDetailModel alloc] init];
    params[@"id"] = self.orderID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/DispatchGoods/dispatchGoodsDetails.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        [self.model setValuesForKeysWithDictionary:dic];
        //获取数据源
        _goodsName.text = _model.goods_name;
        _colorLabel.text = _model.goods_color;
        _sizeLabel.text = _model.goods_size;
        _goodsNum.text = [NSString stringWithFormat:@"X%@", _model.num];
        _goodsPrice.text = [NSString stringWithFormat:@"￥%@", _model.price];
        int a = [_model.num intValue];
        int b = [_model.price intValue];
        int c = a * b;
        _allPrice.text = [NSString stringWithFormat:@"%d", c];
        
        _personName.text = _model.contact_name;
        _shopName.text = _model.shop_name;
        _phoneNum.text = _model.contact_mobile;
        _allPrice.textColor = XZYSPinkColor;
        _goodsPrice.textColor = XZYSPinkColor;
        _goodsNum.textColor = XZYSBlueColor;
        _addressLabel.text = _model.address;
        [_goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _model.goods_img]]];
        // 隐藏指示器
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
}

- (IBAction)cancelTaoHuo:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"id"] = _model.ID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/DispatchGoods/dispatchGoodsDel.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = responseObject[@"msg"];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"取消调货刷新UI" object:self];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
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
