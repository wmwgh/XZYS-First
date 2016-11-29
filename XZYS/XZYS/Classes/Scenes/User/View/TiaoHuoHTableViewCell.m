//
//  TiaoHuoHTableViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/11/14.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "TiaoHuoHTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"

#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@implementation TiaoHuoHTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(SonLislModel *)oneModel {
    _model = oneModel;
    
    _goodsTitle.text = _model.goods_name;
    _numLabel.text = [NSString stringWithFormat:@"数量:%@", _model.num];
    _priceLabel.text = [NSString stringWithFormat:@"价格:%@", _model.price];
    _priceLabel.textColor = XZYSPinkColor;
    _numLabel.textColor = XZYSBlueColor;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _model.goods_img]]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
