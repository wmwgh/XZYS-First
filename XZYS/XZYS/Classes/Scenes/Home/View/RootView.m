//
//  RootView.m
//  UILesson15_UICollectionView
//
//  Created by 郭艳芳 on 16/4/27.
//  Copyright © 2016年 郭艳芳. All rights reserved.
//

#import "RootView.h"
#import "XZYS_Other.h"

@implementation RootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化布局
        [self initLayout];
    }
    return self;
}

// 初始化布局
- (void)initLayout {
    // 1.定义collectionView的样式
    self.myFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置属性
    // 给定item的大小
    self.myFlowLayout.itemSize = CGSizeMake(self.bounds.size.width / 2 - 4, self.bounds.size.width / 2 + 60);
    // 每两个item的最小间隙（垂直滚动）
    self.myFlowLayout.minimumInteritemSpacing = 4;
    // 每两个item的最小间隙（水平滚动方向）
    self.myFlowLayout.minimumLineSpacing = 4;
    
    // 设置滚动方向
    self.myFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;// 垂直方向
    // 设置视图的内边距（上左下右）
    
    self.myFlowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
//    // 布局头视图尺寸  移到了Home 头视图设置中
    self.myFlowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, SCREEN_WIDTH*2.7 / 3.1 + 60);
    // 2.布局collectionView
    
    // 创建对象并指定样式
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 52) collectionViewLayout:self.myFlowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.collectionView];
}

@end
