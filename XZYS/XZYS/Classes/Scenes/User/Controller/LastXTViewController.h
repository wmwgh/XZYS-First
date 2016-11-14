//
//  LastXTViewController.h
//  XZYS
//
//  Created by 杨利 on 16/11/6.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiTongModel.h"

@interface LastXTViewController : UIViewController
@property (nonatomic , strong) XiTongModel *model;
@property (strong, nonatomic) IBOutlet UILabel *titLab;
@property (strong, nonatomic) IBOutlet UIImageView *imaImageView;
@property (strong, nonatomic) IBOutlet UILabel *noteLab;

@end
