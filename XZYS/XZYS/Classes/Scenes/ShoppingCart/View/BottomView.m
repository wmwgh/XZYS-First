//
//  BottomView.m
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import "BottomView.h"
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
@interface BottomView ()

@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UILabel * titleLable;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)UILabel * totalLable;
@property (nonatomic, strong)UIView * lineView;
@end
@implementation BottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.lineView];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.titleLable];
        [self addSubview:self.totalLable];
    }
    return self;
}

#pragma mark -- 

-(UIView *)lineView{
    if (_lineView == nil) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        _lineView.backgroundColor = RGBAColor(200, 200, 200, .5);
        
    }
    return _lineView;
}

- (UIButton *)leftBtn{
    if (_leftBtn == nil) {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(10, 11, 27, 27);
        [_leftBtn setImage:[UIImage imageNamed:@"gw_10"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(clickedLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}


-(UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 100, 20)];
        _titleLable.text = @"全选";
        _titleLable.font = [UIFont systemFontOfSize:15];
    }
    return _titleLable;
}

- (UIButton *)rightBtn{
    if (_rightBtn == nil) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame =CGRectMake(self.frame.size.width - 115, 3, 110, 45);
        _rightBtn.backgroundColor = [UIColor redColor];
        [_rightBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
        _rightBtn.layer.cornerRadius = 5;
        [_rightBtn addTarget:self action:@selector(jieSuanClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(UILabel *)totalLable{
    if (_totalLable == nil) {
        self.totalLable = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100, 15, self.frame.size.width/2 - 50, 20)];
        NSString * string = [NSString stringWithFormat:@"合计:￥0.00"];
        _totalLable.font = [UIFont systemFontOfSize:15];
        _totalLable.textAlignment = NSTextAlignmentRight;
        _totalLable.textColor = [UIColor redColor];
//        _totalLable.backgroundColor = [UIColor yellowColor];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        _totalLable.attributedText = str;
    }
    return _totalLable;
}

#pragma mark---
- (void)clickedLeftBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedBottomSelecteAll)]) {
        [self.delegate clickedBottomSelecteAll];
    }
}


- (void)jieSuanClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedBottomJieSuan)]) {
        [self.delegate clickedBottomJieSuan];
    }
}


#pragma mark -- setter
-(void)setModel:(BottomModel *)model{
    _model = model;
    if (_model.isSelecteAll) {
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_07"] forState:UIControlStateNormal];
    }else{
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_10"] forState:UIControlStateNormal];
    }
//    [self.rightBtn setTitle:[NSString stringWithFormat:@"结算(%zd)", _model.totalCount] forState:UIControlStateNormal];
    
    if (_model.isEdit) {
        [self.rightBtn setTitle:[NSString stringWithFormat:@"删除(%zd)", _model.totalCount] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:[NSString stringWithFormat:@"结算(%zd)", _model.totalCount] forState:UIControlStateNormal];
    }
    NSString * str = [NSString stringWithFormat:@"合计:￥%.2f", _model.totalMoney];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    self.totalLable.attributedText = string;
}


@end
