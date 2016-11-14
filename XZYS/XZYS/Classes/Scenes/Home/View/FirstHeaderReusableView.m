//
//  FirstHeaderReusableView.m
//  XZYS
//
//  Created by 杨利 on 16/8/12.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "FirstHeaderReusableView.h"
#import "XZYS_Other.h"

@implementation FirstHeaderReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 添加子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    
    UIView *bbbbView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_WIDTH*2.7 / 3.1 + 90)];
//    UIView *BView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100, SCREEN_WIDTH*2.7 / 3.1 + 70 - 28, 200, 31)];
    UIView *BView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH*2.7 / 3.1 + 70 - 28, SCREEN_WIDTH, 50)];
    UIImageView *aimage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100, 23, 50, 1)];
    aimage.image = [UIImage imageNamed:@"index_01.jpg"];
    UIImageView *bimage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100 + 150, 23, 50, 1)];
    bimage.image = [UIImage imageNamed:@"index_01.jpg"];
    aimage.userInteractionEnabled = YES;
    bimage.userInteractionEnabled = YES;
    self.oneBtn.userInteractionEnabled = YES;
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 50, 6, 100, 34)];
    self.headerLabel.textColor = XZYSBlueColor;
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    
    self.oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.oneBtn.frame = CGRectMake(30, 5, SCREEN_WIDTH - 60, 45);
    [BView bringSubviewToFront:self.oneBtn];
    [BView addSubview:aimage];
    [BView addSubview:bimage];
    [BView addSubview:self.headerLabel];
    [bbbbView addSubview:BView];
    [BView addSubview:self.oneBtn];
    [self addSubview:bbbbView];
}


@end
