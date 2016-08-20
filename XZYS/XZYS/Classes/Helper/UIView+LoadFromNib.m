//
//  UIView+LoadFromNib.m
//  XZYS
//
//  Created by 杨利 on 16/8/17.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "UIView+LoadFromNib.h"

@implementation UIView (LoadFromNib)

+ (id)loadFromNib
{
    id view = nil;
    NSString *xibName = NSStringFromClass([self class]);
    UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:xibName bundle:nil];
    if (temporaryController) {
     view = temporaryController.view;
    }
    return view;
}


@end
