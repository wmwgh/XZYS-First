//
//  CollectShopViewCell.h
//  XZYS
//
//  Created by 杨利 on 16/9/18.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"

@interface CollectShopViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UILabel *tittle1;
@property (strong, nonatomic) IBOutlet UILabel *price1;

@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UILabel *tittle2;
@property (strong, nonatomic) IBOutlet UILabel *price2;

@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UILabel *tittle3;
@property (strong, nonatomic) IBOutlet UILabel *price3;

@property (strong, nonatomic) IBOutlet UIImageView *img4;
@property (strong, nonatomic) IBOutlet UILabel *tittle4;
@property (strong, nonatomic) IBOutlet UILabel *price4;

@property (strong, nonatomic) IBOutlet UIImageView *img5;
@property (strong, nonatomic) IBOutlet UILabel *tittle5;
@property (strong, nonatomic) IBOutlet UILabel *price5;

@property (strong, nonatomic) IBOutlet UIButton *bt1;
@property (strong, nonatomic) IBOutlet UIButton *bt2;
@property (strong, nonatomic) IBOutlet UIButton *bt3;
@property (strong, nonatomic) IBOutlet UIButton *bt4;
@property (strong, nonatomic) IBOutlet UIButton *bt5;

@property (nonatomic,strong) UIViewController *owner;
@end
