//
//  LoginViewController.h
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

//extern NSString * const isLogin;
@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (nonatomic , copy) NSString *userId;
@end
