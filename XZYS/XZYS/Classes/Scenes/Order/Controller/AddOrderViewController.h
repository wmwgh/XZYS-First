//
//  AddOrderViewController.h
//  XZYS
//
//  Created by 杨利 on 16/9/29.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface AddOrderViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (strong, nonatomic) IBOutlet UIButton *sureOrder;
@property (strong, nonatomic) IBOutlet UILabel *resultLab;
@property (nonatomic , strong) NSMutableArray *cellAllary;
@property (nonatomic , strong) NSMutableArray *orderAllary;
@property (nonatomic, copy) NSString *resultPrice;
@property (nonatomic, copy) NSString *result1;
@property (nonatomic, copy) NSString *result2;
@property (nonatomic, copy) NSString *result3;
@property (nonatomic, copy) NSString *resultID;
@property (nonatomic, copy) NSString *whichVC;
@end
