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

//- (void)setModel:(SPXQModel *)oneModel {
//    _model = oneModel;
//    
//    
////    NSString *str = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL,_twoModel.goods_img];
//    
//    _tittleLabel.text = _model.goods_name;
//    NSString *zhushi = [NSString stringWithFormat:@"注:%@", _model.goods_desc];
//    _zhushiLabel.text = zhushi;
//    NSString *numStr = [NSString stringWithFormat:@"销量:%@件", _model.sales_num];
//    _numLabel.text = _model.sales_num;
//    NSString *beforePrice = [NSString stringWithFormat:@"价格￥%@", _model.ori_price];
//    _beforePrice.text = beforePrice;
//    NSString *price = [NSString stringWithFormat:@"￥%@", _model.price];
//    _priceLabel.text = price;
//    _priceLabel.textColor = XZYSBlueColor;
//    _numLabel.text = numStr;
//    _numLabel.textColor = XZYSPinkColor;
//    _zhushiLabel.textColor = XZYSPinkColor;
//    _beforePrice.textColor = [UIColor orangeColor];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
