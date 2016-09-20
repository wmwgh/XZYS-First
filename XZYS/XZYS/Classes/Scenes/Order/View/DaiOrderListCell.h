//
//  DaiOrderListCell.h
//  XZYS
//
//  Created by 杨利 on 16/8/27.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonLislModel.h"
typedef void(^BlockButton)(UIButton *superID);
@interface DaiOrderListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *goodsImg;
@property (strong, nonatomic) IBOutlet UILabel *goodsTitle;
@property (strong, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic , strong) SonLislModel *model;
@property (strong, nonatomic) IBOutlet UIButton *shouhou;
@property (strong, nonatomic) IBOutlet UIButton *tiaohuo;
@property (nonatomic , copy) NSString *idStr;
//block属性
@property (nonatomic, copy) BlockButton button;
//自定义block方法
- (void)handlerButtonAction:(BlockButton)block;

@end
