//
//  ShopCollectionViewCell.h
//  商品列表
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 YF_S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLModel.h"

@interface ShopCollectionViewCell : UICollectionViewCell

@property (nonatomic,retain) FLModel *oneModel;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
