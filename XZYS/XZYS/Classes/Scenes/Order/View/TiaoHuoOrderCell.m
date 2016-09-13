//
//  TiaoHuoOrderCell.m
//  XZYS
//
//  Created by 杨利 on 16/9/10.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "TiaoHuoOrderCell.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"

#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@implementation TiaoHuoOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SonLislModel *)oneModel {
    _model = oneModel;
    
    _goodsTitle.text = _model.goods_name;
    _colorLabel.text = _model.goods_color;
    _sizeLabel.text = _model.goods_size;
    _numLabel.text = [NSString stringWithFormat:@"X%@", _model.num];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", _model.price];
    _priceLabel.textColor = XZYSPinkColor;
    _numLabel.textColor = XZYSBlueColor;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _model.goods_img]]];
}

- (IBAction)cancel:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"id"] = _model.ID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/DispatchGoods/dispatchGoodsDel.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = responseObject[@"msg"];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
    
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"取消调货刷新UI" object:self];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
