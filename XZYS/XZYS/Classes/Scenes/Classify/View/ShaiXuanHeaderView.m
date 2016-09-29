//
//  ShaiXuanHeaderView.m
//  XZYS
//
//  Created by 杨利 on 16/9/27.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShaiXuanHeaderView.h"

@implementation ShaiXuanHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 添加子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    UIView *BView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 70, 31)];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 25)];
    [BView addSubview:self.headerLabel];
    self.sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sectionButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 163, 0, 70, 25);
    [BView addSubview:self.sectionButton];
    self.sectionImg = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 4, 17, 17)];
    [BView addSubview:self.sectionImg];
    [self addSubview:BView];
}
@end
