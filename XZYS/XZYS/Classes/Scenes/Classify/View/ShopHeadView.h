//
//  ShopHeadView.h
//  XZYS
//
//  Created by 杨利 on 16/8/30.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopHeadView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *baclImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *dianPuCollect;
@property (strong, nonatomic) IBOutlet UILabel *goodsCollect;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *collectButton;
@property (strong, nonatomic) IBOutlet UIView *pickBackView;




@end
