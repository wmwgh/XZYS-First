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
@property (strong, nonatomic) IBOutlet UIImageView *sfzImgBefore;
@property (strong, nonatomic) IBOutlet UIImageView *sfzImgAfter;
@property (strong, nonatomic) IBOutlet UIImageView *zhizhaoImg;
@property (strong, nonatomic) IBOutlet UIButton *useProBtn;
@property (strong, nonatomic) IBOutlet UIButton *personBtn;

@end
