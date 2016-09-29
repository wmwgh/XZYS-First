//
//  EditAddressController.h
//  XZYS
//
//  Created by 杨利 on 16/9/23.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddressController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameLab;
@property (strong, nonatomic) IBOutlet UITextField *numLab;
@property (strong, nonatomic) IBOutlet UILabel *sectionCityLab;
@property (strong, nonatomic) IBOutlet UITextView *addressLab;
@property (strong, nonatomic) IBOutlet UIImageView *chooseImg;
@property (strong, nonatomic) IBOutlet UIButton *chooseBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic , copy) NSString *addressID;
@end
