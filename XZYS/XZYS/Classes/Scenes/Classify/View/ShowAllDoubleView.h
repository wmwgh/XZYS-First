//
//  ShowAllDoubleView.h
//  XZYS
//
//  Created by 杨利 on 16/8/21.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowAllDoubleView : UIView
// 声明集合视图属性
@property (nonatomic, strong) UICollectionView *collectionView;

// UICollectionViewFlowLayout用来给collectionView布局
@property (nonatomic, strong) UICollectionViewFlowLayout *myFlowLayout;
@end
