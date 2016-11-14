//
//  DaiOrderListCell.m
//  XZYS
//
//  Created by 杨利 on 16/8/27.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "DaiOrderListCell.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"
#import "RequestShouHouController.h"
#import "RequestTiaoHuoController.h"

@implementation DaiOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.shouhou setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.tiaohuo setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    // Initialization code
}

- (void)setModel:(SonLislModel *)oneModel {
    _model = oneModel;
    
    if (_model.goods_name != nil && ![_model.goods_name isEqualToString:@""]) {
        _goodsTitle.text = _model.goods_name;
    }
    if (_model.goods_color != nil && ![_model.goods_color isEqualToString:@""]) {
        _colorLabel.text = _model.goods_color;
    }
    if (_model.goods_size != nil && ![_model.goods_size isEqualToString:@""]) {
        _sizeLabel.text = _model.goods_size;
    }
    if (_model.num != nil && ![_model.num isEqualToString:@""]) {
        _numLabel.text = [NSString stringWithFormat:@"X%@", _model.num];
    }
    if (_model.price != nil && ![_model.price isEqualToString:@""]) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%@", _model.price];
    }
    
    if (_model.cotton_id != nil && ![_model.cotton_id isEqualToString:@""]) {
        NSString *strnl = nil;
        if ([_model.cotton_id isEqualToString:@"1"]) {
            strnl = @"单里";
        } else if ([_model.cotton_id isEqualToString:@"2"]){
            strnl = @"棉里";
        }
        self.nlLab.text = [NSString stringWithFormat:@"内里:  %@", strnl];
    }
    
    _priceLabel.textColor = XZYSPinkColor;
    _numLabel.textColor = XZYSBlueColor;
    if (_model.goods_img != nil && ![_model.goods_img isEqualToString:@""]) {
        [_goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _model.goods_img]]];
    }
}

- (IBAction)shouHouAction:(id)sender {
    //发出通知
    NSString *idStr =  [NSString stringWithFormat:@"%ld", (long)_tiaohuo.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"申请售后" object:self userInfo:[NSDictionary dictionaryWithObject:idStr forKey:@"sid"]];
    if (self.button) {
        self.button(self.shouhou);
    }
}
- (IBAction)tiaoHuoAction:(id)sender {
    _idStr =  [NSString stringWithFormat:@"%ld", (long)_tiaohuo.tag];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"调货跳转" object:self userInfo:[NSDictionary dictionaryWithObject:_idStr forKey:@"gid"]];
    
    if (self.button) {
        self.button(self.tiaohuo);
    }
}
//block的实现部分
- (void)handlerButtonAction:(BlockButton)block
{
    self.button = block;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
