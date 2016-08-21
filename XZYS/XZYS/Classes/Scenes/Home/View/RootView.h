//
//  RootView.h
//  UILesson15_UICollectionView
//
//  Created by 郭艳芳 on 16/4/27.
//  Copyright © 2016年 郭艳芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootView : UIView

// 声明集合视图属性
@property (nonatomic, strong) UICollectionView *collectionView;

// UICollectionViewFlowLayout用来给collectionView布局
@property (nonatomic, strong) UICollectionViewFlowLayout *myFlowLayout;

@end