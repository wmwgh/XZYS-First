//
//  PickerViewHeaderView.m
//  choose
//
//  Created by 杨利 on 16/9/21.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "PickerViewHeaderView.h"

@implementation PickerViewHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 添加子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    UIView *BView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 200, 31)];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [BView addSubview:self.headerLabel];
    [self addSubview:BView];
}
@end
