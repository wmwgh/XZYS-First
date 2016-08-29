//
//  RegiestView.h
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegiestView : UIView
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UITextField *passWordAgain;
@property (strong, nonatomic) IBOutlet UITextField *yanZhengMa;
@property (strong, nonatomic) IBOutlet UIButton *yanZhengMaButton;
@property (strong, nonatomic) IBOutlet UIButton *regiestButton;
@property (strong, nonatomic) IBOutlet UITextField *farenName;

@end
