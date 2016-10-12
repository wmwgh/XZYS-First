//
//  ShopCarTableViewCell.h
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllGucModel.h"

@protocol ShopCarTableViewCellDelegate <NSObject>
@optional
- (void)clickedWichLeftBtn:(UITableViewCell *)cell;
- (void)changeTheShopCount:(UITableViewCell *)cell count:(NSInteger )count;
@end
@interface ShopCarTableViewCell : UITableViewCell

@property (nonatomic, strong)AllGucModel * model;

@property (strong, nonatomic) IBOutlet UILabel *nlLab;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (strong, nonatomic) IBOutlet UILabel *colorTittle;
@property (strong, nonatomic) IBOutlet UILabel *sizeLb;
@property (strong, nonatomic) IBOutlet UIImageView *goodsImg;

@property (nonatomic, assign)id<ShopCarTableViewCellDelegate>delegate;
@end
