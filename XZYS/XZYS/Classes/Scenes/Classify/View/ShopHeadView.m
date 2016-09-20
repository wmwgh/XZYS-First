//
//  ShopHeadView.m
//  XZYS
//
//  Created by 杨利 on 16/8/30.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShopHeadView.h"
#import "ShopViewController.h"
@implementation ShopHeadView

- (IBAction)collect:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cbt1" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
