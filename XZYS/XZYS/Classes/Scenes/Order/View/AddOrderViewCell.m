//
//  AddOrderViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/9/29.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "AddOrderViewCell.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"

@implementation AddOrderViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
