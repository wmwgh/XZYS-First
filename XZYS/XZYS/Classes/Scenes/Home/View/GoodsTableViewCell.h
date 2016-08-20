//
//  GoodsTableViewCell.h
//  XZYS
//
//  Created by 杨利 on 16/8/18.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPXQModel.h"

@interface GoodsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UILabel *tittleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *zhushiLabel;

@property (strong, nonatomic) IBOutlet UILabel *beforePrice;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *changeHeight;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UIView *changeView;
@property (nonatomic ,strong) SPXQModel *model;

@end
