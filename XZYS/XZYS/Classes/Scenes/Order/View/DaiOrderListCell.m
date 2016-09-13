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
    
    _goodsTitle.text = _model.goods_name;
    _colorLabel.text = _model.goods_color;
    _sizeLabel.text = _model.goods_size;
    _numLabel.text = [NSString stringWithFormat:@"X%@", _model.num];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", _model.price];
    _priceLabel.textColor = XZYSPinkColor;
    _numLabel.textColor = XZYSBlueColor;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _model.goods_img]]];
}

- (IBAction)shouHouAction:(id)sender {
    RequestShouHouController *shouHouVC = [[RequestShouHouController alloc] init];
    [self.owner.navigationController pushViewController:shouHouVC animated:YES];
    NSLog(@"%ld", _shouhou.tag);
}
- (IBAction)tiaoHuoAction:(id)sender {
    RequestTiaoHuoController *shouHouVC = [[RequestTiaoHuoController alloc] init];
    [self.owner.navigationController pushViewController:shouHouVC animated:YES];
    NSLog(@"%ld", _tiaohuo.tag);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
