//
//  RootCell.m
//  UILesson15_UICollectionView
//
//  Created by 郭艳芳 on 16/4/27.
//  Copyright © 2016年 郭艳芳. All rights reserved.
//

#import "RootCell.h"

@implementation RootCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 布局子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    
    
    UIView *aView = [[UIView alloc] initWithFrame:self.bounds];
    // 创建对象
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    self.photoImage.layer.cornerRadius = 3;
    self.photoImage.layer.masksToBounds = YES;
    self.tittleLable = [[UILabel alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(self.photoImage.frame) + 3, CGRectGetWidth(self.frame) - 5, 35)];
    self.tittleLable.backgroundColor = [UIColor brownColor];
    
    self.priceLable = [[UILabel alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(self.tittleLable.frame) + 3, 80, 20)];
    self.priceLable.textAlignment = NSTextAlignmentLeft;
    self.priceLable.backgroundColor = [UIColor brownColor];
    
    self.NumberLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 82, CGRectGetMaxY(self.tittleLable.frame) + 3, 80, 20)];
    self.NumberLable.textAlignment = NSTextAlignmentRight;
    self.NumberLable.backgroundColor = [UIColor brownColor];
    
    [aView addSubview:self.photoImage];
    [aView addSubview:self.tittleLable];
    [aView addSubview:self.priceLable];
    [aView addSubview:self.NumberLable];
    
    [self.contentView addSubview:aView];
}


@end
