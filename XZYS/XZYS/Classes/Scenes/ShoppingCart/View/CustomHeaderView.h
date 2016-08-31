//
//  CustomHeaderView.h
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarModel.h"

@protocol CustomHeaderViewDelegate <NSObject>

- (void)clickedWhichHeaderView:(NSInteger)index;

@end
@interface CustomHeaderView : UIView


@property (nonatomic, strong)ShopCarModel * model;

@property (nonatomic, weak)id<CustomHeaderViewDelegate>delegate;
@end
