//
//  CustomHeaderView.m
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import "CustomHeaderView.h"
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
@interface CustomHeaderView ()
@property (nonatomic, strong)UIView * topView;
@property (nonatomic, strong)UIButton * leftBtn;
@property (nonatomic, strong)UIImageView *imgV;
@end

@implementation CustomHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAColor(249, 249, 249, 1.0);
        [self addSubview:self.topView];
        [self addSubview:self.leftBtn];
        [self addSubview:self.titleLable];
        [self addSubview:self.tittleBtn];
        [self addSubview:self.imgV];
    }
    return self;
}

#pragma mark -- Lazy Loading

-(UIView *)topView{
    if (_topView == nil) {
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
        _topView.backgroundColor = RGBAColor(240, 240, 240, 1);
    }
    return _topView;
}

- (UIImageView *)imgV {
    if (_imgV == nil) {
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 23, 13, 16)];
        self.imgV.image = [UIImage imageNamed:@"gw_13"];
    }
    return _imgV;
}

-(UIButton *)leftBtn{
    if (_leftBtn == nil) {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(10, 17, 27, 27);
        [_leftBtn setImage:[UIImage imageNamed:@"gw_10"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIButton *)tittleBtn{
    if (_tittleBtn == nil) {
        self.tittleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tittleBtn.frame = CGRectMake(45, 11, 350, 37);
        _tittleBtn.backgroundColor = [UIColor clearColor];
        [_tittleBtn addTarget:self action:@selector(clicked1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tittleBtn;
}

-(UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 200, 20)];
        _titleLable.text = @"店铺名称";
        _titleLable.font = [UIFont systemFontOfSize:16];
    }
    return _titleLable;
}

#pragma mark --- Clicked event
- (void)clicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedWhichHeaderView:)]) {
        [self.delegate clickedWhichHeaderView:self.tag];
    }
}
- (void)clicked1:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"titleCall" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}

-(void)setModel:(ShopCarModel *)model{
    _model = model;
    self.titleLable.text = _model.shop_name;
    if (_model.isChecked) {
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_07"] forState:UIControlStateNormal];
    }else{
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_10"] forState:UIControlStateNormal];
    }
}

@end
