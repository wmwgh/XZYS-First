//
//  ShopHeadReusableView.m
//  XZYS
//
//  Created by 杨利 on 16/10/7.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShopHeadReusableView.h"
#import "XZYS_Other.h"

@implementation ShopHeadReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 添加子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    self.baclImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 176)];
    [self addSubview:self.baclImageView];
    UIImageView *tmpimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 151, SCREEN_WIDTH, 25)];
    tmpimg.image = [UIImage imageNamed:@"tm.png"];
    [self addSubview:tmpimg];
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 145, 65, 65)];
    self.headImageView.backgroundColor = XZYSRGBColor(234, 234, 234);
    [self addSubview:self.headImageView];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+ 5, CGRectGetMinY(tmpimg.frame), 50, 25)];
    lab1.font = [UIFont systemFontOfSize:11];
    lab1.text = @"商品数量:";
    lab1.textColor = [UIColor whiteColor];
    [self addSubview:lab1];

    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame), CGRectGetMinY(tmpimg.frame), 40, 25)];
    self.numLabel.font = [UIFont systemFontOfSize:11];
    self.numLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.numLabel];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numLabel.frame), CGRectGetMinY(tmpimg.frame), 50, 25)];
    lab2.font = [UIFont systemFontOfSize:11];
    lab2.textColor = [UIColor whiteColor];
    lab2.text = @"商品销量:";
    [self addSubview:lab2];
    
    self.goodsCollect = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab2.frame), CGRectGetMinY(tmpimg.frame), 40, 25)];
    self.goodsCollect.textColor = [UIColor whiteColor];
    self.goodsCollect.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.goodsCollect];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsCollect.frame), CGRectGetMinY(tmpimg.frame), 50, 25)];
    lab3.font = [UIFont systemFontOfSize:11];
    lab3.textColor = [UIColor whiteColor];
    lab3.text = @"收藏数量:";
    [self addSubview:lab3];
    
    self.dianPuCollect = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab3.frame), CGRectGetMinY(tmpimg.frame), 40, 25)];
    self.dianPuCollect.textColor = [UIColor whiteColor];
    self.dianPuCollect.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.dianPuCollect];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 5, CGRectGetMaxY(tmpimg.frame), SCREEN_WIDTH - 140, 40)];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    
    self.pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headImageView.frame), SCREEN_WIDTH, 35)];
    [self addSubview:self.pickBackView];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
