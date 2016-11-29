//
//  OrderListViewController.h
//  XZYS
//
//  Created by 杨利 on 16/8/27.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *allButton;
@property (strong, nonatomic) IBOutlet UIButton *daiPay;
@property (strong, nonatomic) IBOutlet UIButton *yiPay;

@property (strong, nonatomic) IBOutlet UIButton *daiReceive;
@property (strong, nonatomic) IBOutlet UIButton *complateButton;
@property (nonatomic , copy) NSString *payResultMSGAction;
@property (nonatomic , copy) NSString *payResultMSG;
@property (strong, nonatomic) UIView *lineView;
@property (nonatomic , assign) NSInteger orderType;
@end
