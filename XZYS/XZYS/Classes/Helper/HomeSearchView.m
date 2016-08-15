//
//  HomeSearchView.m
//  XZYS
//
//  Created by 杨利 on 16/8/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "HomeSearchView.h"

@implementation HomeSearchView




- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        
        // 设置背景
        self.backgroundColor = [UIColor whiteColor];
        
        // 设置左边的view
//        [self setLeftView];
        
        // 设置右边的录音按钮
//        [self setRightView];
        
    }
    
    return self;
}

- (instancetype)init {
    // 设置frame
    CGFloat width = self.frame.size.width;
    CGFloat height = 88;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGRect frame = CGRectMake(X, Y, width, height);
    
    return [self initWithFrame:frame];
}

//// 设置左边的view
//- (void)setLeftView {
//    
//    // initWithImage:默认UIImageView的尺寸跟图片一样
//    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_07"]];
//    
//    UIButton *leftButton = [UIButton buttonWithType:]
//    
//}
//
//// 设置右边的view
//- (void)setRightView {
//    // 创建按钮
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setImage:[UIImage imageNamed:@"audio_nav_icon"] forState:UIControlStateNormal];
//    [rightButton sizeToFit];
//    // 将imageView宽度
//    rightButton.frameWidth += 10;
//    //居中
//    rightButton.contentMode = UIViewContentModeCenter;
//    
//    
//    self.rightView = rightButton;
//    //  注意：一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
//    self.rightViewMode = UITextFieldViewModeAlways;}

@end
