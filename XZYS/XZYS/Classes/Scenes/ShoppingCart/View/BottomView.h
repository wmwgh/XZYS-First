//
//  BottomView.h
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomModel.h"

@protocol BottomViewDelegate <NSObject>

- (void)clickedBottomSelecteAll;

- (void)clickedBottomJieSuan;

@end
@interface BottomView : UIView

@property (nonatomic, weak)id<BottomViewDelegate>delegate;

@property (nonatomic, strong)BottomModel * model;

@end
