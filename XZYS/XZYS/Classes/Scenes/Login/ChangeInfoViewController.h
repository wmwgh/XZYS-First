//
//  ChangeInfoViewController.h
//  XZYS
//
//  Created by 杨利 on 16/9/1.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

//获取系统版本号
#define IS_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
//获取屏幕尺寸
#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height
#import <UIKit/UIKit.h>

@interface ChangeInfoViewController : UIViewController

<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIView *headImgView;
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *outButton;
@property (strong, nonatomic) IBOutlet UIButton *manButton;
@property (strong, nonatomic) IBOutlet UIButton *nvButton;
@property (strong, nonatomic) IBOutlet UITextField *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *sectionLabel;
@property (strong, nonatomic) IBOutlet UITextView *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
//@property (strong, nonatomic) IBOutlet UIButton *iconBtn;
@property (nonatomic, strong)UIButton *iconBtn;

@end
