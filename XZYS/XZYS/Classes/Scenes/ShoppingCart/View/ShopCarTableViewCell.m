//
//  ShopCarTableViewCell.m
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import "ShopCarTableViewCell.h"
#import "CountView.h"

@interface ShopCarTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet CountView *countview;

@end
@implementation ShopCarTableViewCell

- (void)awakeFromNib {
    __weak typeof(self)MySelf = self;
    self.countview.CountBlock = ^(NSInteger num){
        if (MySelf.delegate && [self.delegate respondsToSelector:@selector(changeTheShopCount:count:)]) {
            [MySelf.delegate changeTheShopCount:MySelf count:num];
        }
    };
}

-(void)setModel:(GwcShopModel *)model{
    _model = model;
    self.shopTitle.text = _model.shopTitle;
    self.priceLable.text = [NSString stringWithFormat:@"￥%.2f", _model.singlePrice];
    self.countview.count =  _model.count;
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
