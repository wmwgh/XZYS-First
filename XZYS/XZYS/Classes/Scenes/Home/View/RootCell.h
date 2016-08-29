//
//  RootCell.h
//  UILesson15_UICollectionView
//
//  Created by 郭艳芳 on 16/4/27.
//  Copyright © 2016年 郭艳芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFQModel.h"
#import "SPXQModel.h"
#import "ShopModel.h"
@interface RootCell : UICollectionViewCell

// 声明imageView的子控件
@property (nonatomic , strong) UIImageView *photoImage;
@property(nonatomic ,strong) UILabel *tittleLable;
@property(nonatomic ,strong) UILabel *priceLable;
@property(nonatomic ,strong) UILabel *NumberLable;

@property (nonatomic ,retain) SDFQModel *oneModel;

@property (nonatomic ,retain) SPXQModel *twoModel;
@property (nonatomic ,retain) ShopModel *shopModel;

@end
