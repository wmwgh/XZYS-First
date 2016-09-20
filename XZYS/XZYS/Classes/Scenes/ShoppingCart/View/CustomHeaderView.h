//
//  CustomHeaderView.h
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllGucModel.h"

@protocol CustomHeaderViewDelegate <NSObject>

- (void)clickedWhichHeaderView:(NSInteger)index;

@end
@interface CustomHeaderView : UIView
@property (nonatomic, strong)UIButton * tittleBtn;
@property (nonatomic, strong)UILabel * titleLable;
@property (nonatomic, strong)AllGucModel * model;

@property (nonatomic, weak)id<CustomHeaderViewDelegate>delegate;
@end
