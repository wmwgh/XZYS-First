//
//  ShopHeadReusableView.h
//  XZYS
//
//  Created by 杨利 on 16/10/7.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopHeadReusableView : UICollectionReusableView
@property (strong, nonatomic)  UIImageView *baclImageView;
@property (strong, nonatomic)  UIImageView *headImageView;
@property (strong, nonatomic)  UILabel *numLabel;
@property (strong, nonatomic)  UILabel *dianPuCollect;
@property (strong, nonatomic)  UILabel *goodsCollect;
@property (strong, nonatomic)  UILabel *titleLabel;

@property (strong, nonatomic)  UIView *pickBackView;
@end
