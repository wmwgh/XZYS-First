//
//  CountView.m
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/26.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import "CountView.h"

#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
@interface CountView ()<UITextFieldDelegate>
@property (nonatomic, strong)UIView * leftLineView;
@property (nonatomic, strong)UIView * rightLineView;

@end
@implementation CountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftBtn];
        [self addSubview:self.leftLineView];
        [self addSubview:self.countTF];
        [self addSubview:self.rightLineView];
        [self addSubview:self.rightBtn];
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 1;
        self.layer.borderColor = RGBAColor(240, 240, 240, 1).CGColor;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.leftBtn];
        [self addSubview:self.leftLineView];
        [self addSubview:self.countTF];
        [self addSubview:self.rightLineView];
        [self addSubview:self.rightBtn];
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 1;
        self.layer.borderColor = RGBAColor(200, 200, 200, 1).CGColor;
    }
    return self;
}

#pragma mark -- LazyLoding
-(UIButton *)leftBtn{
    if (_leftBtn == nil) {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, self.frame.size.width * 2/7 + 3, self.frame.size.height);
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"shopCar_cut"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(cutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIView *)leftLineView{
    if (_leftLineView == nil) {
        self.leftLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftBtn.frame), 0, 1, self.frame.size.height)];
        _leftLineView.backgroundColor = RGBAColor(240, 240, 240, 1);
    }
    return _leftLineView;
}

- (UITextField *)countTF{
    if (_countTF == nil) {
        self.countTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftLineView.frame), 0, self.frame.size.width * 2/7 + 3, self.frame.size.height)];
        _countTF.font = [UIFont systemFontOfSize:14];
        _countTF.textAlignment = NSTextAlignmentCenter;
        _countTF.keyboardType = UIKeyboardTypeNumberPad;
        _countTF.delegate = self;
    }
    return _countTF;
}

-(UIView *)rightLineView{
    if (_rightLineView == nil) {
        self.rightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_countTF.frame), 0, 1, self.frame.size.height)];
        _rightLineView.backgroundColor = RGBAColor(240, 240, 240, 1);
    }
    return _rightLineView;
}

-(UIButton *)rightBtn{
    if (_rightBtn == nil) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(CGRectGetMaxX(_rightLineView.frame), 0, self.frame.size.width * 2/7 + 3, self.frame.size.height);
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"gw_19"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(plusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.CountBlock) {
        self.CountBlock([textField.text intValue]);
        NSString *str = [NSString stringWithFormat:@"%d", [textField.text intValue]];
        NSString *strTag = [NSString stringWithFormat:@"%ld", self.countTF.tag];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"num"] = str;
        dic[@"id"] = strTag;
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"textCall" object:self userInfo:dic];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.countTF resignFirstResponder];
    return YES;
}

#pragma mark -- 按钮响应事件
- (void)cutBtnClicked{//减少
    [self.countTF resignFirstResponder];
    NSInteger count = [self.countTF.text integerValue] - 1;
    if (count <= 0) {
        return;
    }
    if (count == 1) {
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_17"] forState:UIControlStateNormal];
    }
    self.countTF.text = [NSString stringWithFormat:@"%zd", count];
    if (self.CountBlock) {
        self.CountBlock(count);
        NSString *str = [NSString stringWithFormat:@"%ld", count];
        NSString *strTag = [NSString stringWithFormat:@"%ld", self.leftBtn.tag];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"num"] = str;
        dic[@"id"] = strTag;
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"minCall" object:self userInfo:dic];
    }
}

- (void)plusBtnClicked{//增加
    [self.countTF resignFirstResponder];
    NSInteger count = [self.countTF.text integerValue] + 1;
    self.countTF.text = [NSString stringWithFormat:@"%zd", count];
    [self.leftBtn setImage:[UIImage imageNamed:@"gw_17_1"] forState:UIControlStateNormal];
    if (self.CountBlock) {
        self.CountBlock(count);
        NSString *str = [NSString stringWithFormat:@"%ld", count];
        NSString *strTag = [NSString stringWithFormat:@"%ld", self.rightBtn.tag];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"num"] = str;
        dic[@"id"] = strTag;
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"plusCall" object:self userInfo:dic];
    }
}

#pragma mark ----

-(void)setCount:(NSInteger)count{
    _count = count;
    self.countTF.text = [NSString stringWithFormat:@"%zd", _count];
    if (count == 1) {
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_17"] forState:UIControlStateNormal];
    }else{
        [self.leftBtn setImage:[UIImage imageNamed:@"gw_17_1"] forState:UIControlStateNormal];
    }
}



@end
