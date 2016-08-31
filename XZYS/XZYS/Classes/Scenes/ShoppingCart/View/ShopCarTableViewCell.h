//
//  ShopCarTableViewCell.h
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GwcShopModel.h"

@protocol ShopCarTableViewCellDelegate <NSObject>
@optional
- (void)clickedWichLeftBtn:(UITableViewCell *)cell;
- (void)changeTheShopCount:(UITableViewCell *)cell count:(NSInteger )count;
@end
@interface ShopCarTableViewCell : UITableViewCell

@property (nonatomic, strong)GwcShopModel * model;


@property (nonatomic, assign)id<ShopCarTableViewCellDelegate>delegate;
@end
