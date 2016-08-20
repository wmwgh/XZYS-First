//
//  Goods.h
//  XZYS
//
//  Created by 杨利 on 16/8/16.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FzhScrollViewAndPageView.h"

@interface Goods : UIView

@property (nonatomic, strong) UIView *goodsView;
@property (nonatomic, strong) UILabel *tittleLabel;
@property (nonatomic ,strong) NSMutableArray *picArray;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *zhuLabel;
@property (nonatomic, strong) UILabel *beforePrice;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *colorSizeLabel;
/// 轮播图
@property (nonatomic, strong) FzhScrollViewAndPageView *lbtView;

@end
