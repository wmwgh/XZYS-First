//
//  UserHeaderView.m
//  XZYS
//
//  Created by 杨利 on 16/8/22.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "UserHeaderView.h"

@implementation UserHeaderView


// 修改个人信息
- (IBAction)changeMessage:(id)sender {
    NSLog(@"1");
}
// 修改密码
- (IBAction)changePassWord:(id)sender {
    NSLog(@"2");
}
// 查看全部订单
- (IBAction)allDingDan:(id)sender {
    NSLog(@"3");
}
// 待付款
- (IBAction)daiFukuan:(id)sender {
    NSLog(@"4");
}
// 待收货
- (IBAction)daiShouHuo:(id)sender {
    NSLog(@"5");
}
// 已支付
- (IBAction)yiZhiFu:(id)sender {
    NSLog(@"6");
}
// 已完成
- (IBAction)yiWanCheng:(id)sender {
    NSLog(@"7");
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
