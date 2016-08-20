//
//  GoodsTableViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/8/18.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SPXQModel *)oneModel {
    _model = oneModel;
    _tittleLabel.text = _model.goods_name;
    _priceLabel.text = _model.price;
    _beforePrice.text = _model.ori_price;
    _zhushiLabel.text = _model.goods_desc;
    _numLabel.text = _model.sales_num;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
