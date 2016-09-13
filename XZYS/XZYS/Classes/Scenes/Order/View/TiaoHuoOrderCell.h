//
//  TiaoHuoOrderCell.h
//  XZYS
//
//  Created by 杨利 on 16/9/10.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonLislModel.h"

@interface TiaoHuoOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goodsImg;
@property (strong, nonatomic) IBOutlet UILabel *goodsTitle;
@property (strong, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic , strong) SonLislModel *model;
@property (strong, nonatomic) IBOutlet UIButton *tiaohuo;
@end
