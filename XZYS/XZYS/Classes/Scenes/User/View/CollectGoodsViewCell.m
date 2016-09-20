//
//  CollectGoodsViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/9/18.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "CollectGoodsViewCell.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"

@implementation CollectGoodsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(SonLislModel *)oneModel {
    _model = oneModel;
    
    _goodsTitle.text = _model.goods_name;
    _colorLabel.text = _model.goods_color;
    _sizeLabel.text = _model.goods_size;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", _model.price];
    _priceLabel.textColor = XZYSPinkColor;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _model.goods_img]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
