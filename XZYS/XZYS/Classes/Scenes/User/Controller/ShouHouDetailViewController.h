//
//  ShouHouDetailViewController.h
//  XZYS
//
//  Created by 杨利 on 16/10/5.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouHouDetailViewController : UIViewController
@property (nonatomic , copy) NSString *orderID;
@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UILabel *shouHouOrder;
@property (strong, nonatomic) IBOutlet UIImageView *goodsImg;
@property (strong, nonatomic) IBOutlet UILabel *colorLab;
@property (strong, nonatomic) IBOutlet UILabel *sizeLab;
@property (strong, nonatomic) IBOutlet UILabel *numLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *jinduLab;
@property (strong, nonatomic) IBOutlet UILabel *heji1;

@property (strong, nonatomic) IBOutlet UILabel *reasonLab;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UILabel *goodsName;




@end
