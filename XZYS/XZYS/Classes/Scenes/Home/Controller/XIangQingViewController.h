//
//  XIangQingViewController.h
//  XZYS
//
//  Created by 杨利 on 16/8/16.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFQModel.h"


@interface XIangQingViewController : UIViewController

@property (nonatomic ,strong) NSMutableArray *allDataArray;
@property (nonatomic ,strong) SDFQModel *model;
@property (nonatomic , copy) NSString *passID;

@end
