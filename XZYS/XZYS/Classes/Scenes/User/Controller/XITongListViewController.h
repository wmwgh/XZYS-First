//
//  XITongListViewController.h
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiTongModel.h"

@interface XITongListViewController : UIViewController
@property (nonatomic , strong) XiTongModel *model;
@property (nonatomic , copy) NSString *typeID;
@end
