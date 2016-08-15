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
    
    UIView *bbbbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 369)];
    
    UIView *BView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100, 341, 200, 31)];
    UIImageView *aimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 50, 1)];
    aimage.image = [UIImage imageNamed:@"index_01.jpg"];
    UIImageView *bimage = [[UIImageView alloc] initWithFrame:CGRectMake(150, 15, 50, 1)];
    bimage.image = [UIImage imageNamed:@"index_01.jpg"];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 3, 100, 25)];
    self.headerLabel.textColor = XZYSBlueColor;
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    [BView addSubview:aimage];
    [BView addSubview:bimage];
    [BView addSubview:self.headerLabel];
    [bbbbView addSubview:BView];
    [self addSubview:bbbbView];
}
@end
