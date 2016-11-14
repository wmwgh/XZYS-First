//
//  HeaderReusableView.m
//  UILesson15_UICollectionView
//
//  Created by 郭艳芳 on 16/4/27.
//  Copyright © 2016年 郭艳芳. All rights reserved.
//

#import "HeaderReusableView.h"
#import "XZYS_Other.h"

@implementation HeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 添加子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    UIView *BView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100, 3, 220, 51)];
    UIImageView *aimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 50, 1)];
    aimage.image = [UIImage imageNamed:@"index_01.jpg"];
    UIImageView *bimage = [[UIImageView alloc] initWithFrame:CGRectMake(150, 15, 50, 1)];
    bimage.image = [UIImage imageNamed:@"index_01.jpg"];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 3, 100, 25)];
    self.headerLabel.textColor = XZYSBlueColor;
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *zhuLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerLabel.frame)- 3, 200, 20)];
    zhuLab.text = @"查看更多商品";
    zhuLab.textAlignment = NSTextAlignmentCenter;
    zhuLab.font = [UIFont systemFontOfSize:12];
    zhuLab.textColor = XZYSBlueColor;
    self.asdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BView addSubview:zhuLab];
//    [asdBtn addTarget:self action:@selector(buntnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.asdBtn.frame = CGRectMake(0, 3, 200, 45);
//    self.asdBtn.backgroundColor = [UIColor redColor];
    [BView addSubview:aimage];
    [BView addSubview:bimage];
    [BView addSubview:self.headerLabel];
    [BView addSubview:self.asdBtn];
    [self addSubview:BView];
}


@end
