//
//  ShopCarTableViewCell.m
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import "ShopCarTableViewCell.h"
#import "CountView.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"

@interface ShopCarTableViewCell ()
@property (weak, nonatomic) IBOutlet CountView *countview;

@end
@implementation ShopCarTableViewCell

- (void)awakeFromNib {
    __weak typeof(self)MySelf = self;
    self.countview.CountBlock = ^(NSInteger num){
        if (MySelf.delegate && [self.delegate respondsToSelector:@selector(changeTheShopCount:count:)]) {
            [MySelf.delegate changeTheShopCount:MySelf count:num];
            NSLog(@"num=================%ld", num);
        }
    };
}

-(void)setModel:(AllGucModel *)model{
    _model = model;
    self.goodsTitle.text = _model.goods_name;
    self.priceLable.text = [NSString stringWithFormat:@"￥%@", _model.price];
    self.colorTittle.text = [NSString stringWithFormat:@"颜色分类:%@", _model.goods_color];
    self.sizeLb.text = [NSString stringWithFormat:@"尺寸:%@", _model.goods_size];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _model.goods_img]]];
    self.countview.leftBtn.tag = [_model.ID intValue];
    self.countview.rightBtn.tag = [_model.ID intValue];
    self.countview.countTF.tag = [_model.ID intValue];
    self.countview.count =  [_model.num intValue];
    
    if (_model.selected) {
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_07"] forState:UIControlStateNormal];
    }else{
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_10"] forState:UIControlStateNormal];
    }
}

- (IBAction)leftBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedWichLeftBtn:)]) {
        [self.delegate clickedWichLeftBtn:self];
    }
}
@end
