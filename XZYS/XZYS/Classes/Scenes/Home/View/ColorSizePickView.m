//
//  ColorSizePickView.m
//  choose
//
//  Created by 杨利 on 16/9/21.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ColorSizePickView.h"

@implementation ColorSizePickView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化布局
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    // 1.定义collectionView的样式
    self.myFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置属性
    // 给定item的大小
    self.myFlowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 5, 30);
    // 每两个item的最小间隙（垂直滚动）
    self.myFlowLayout.minimumInteritemSpacing = 5;
    // 每两个item的最小间隙（水平滚动方向）
    self.myFlowLayout.minimumLineSpacing = 5;
    
    // 设置滚动方向
    self.myFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;// 垂直方向
    self.myFlowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 30);
    self.myFlowLayout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);        
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
