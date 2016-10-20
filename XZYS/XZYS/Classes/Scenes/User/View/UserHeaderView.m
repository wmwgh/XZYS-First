//
//  UserHeaderView.m
//  XZYS
//
//  Created by 杨利 on 16/8/22.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "UserHeaderView.h"
#import "OrderListViewController.h"
#import "PassWordViewController.h"
#import "ChangeInfoViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@implementation UserHeaderView

// 修改个人信息
- (IBAction)changeMessage:(id)sender {
    ChangeInfoViewController *changeVC = [[ChangeInfoViewController alloc] init];
    changeVC.hidesBottomBarWhenPushed = YES;
    [self.owner.navigationController  pushViewController:changeVC animated:YES];
}
// 修改密码
- (IBAction)changePassWord:(id)sender {
    PassWordViewController *passVC = [[PassWordViewController alloc] init];
    passVC.orderTypeId = @"2";
    passVC.hidesBottomBarWhenPushed = YES;
    [self.owner.navigationController  pushViewController:passVC animated:YES];
}
// 查看全部订单
- (IBAction)allDingDan:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.hidesBottomBarWhenPushed = YES;
    order.orderType = 0;
    [self.owner.navigationController  pushViewController:order animated:YES];
}
// 待付款
- (IBAction)daiFukuan:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.orderType = 1;
    order.hidesBottomBarWhenPushed = YES;
    [self.owner.navigationController  pushViewController:order animated:YES];
}
// 待收货
- (IBAction)daiShouHuo:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.orderType = 2;
    order.hidesBottomBarWhenPushed = YES;
    [self.owner.navigationController  pushViewController:order animated:YES];
}
// 已支付
- (IBAction)yiZhiFu:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.orderType = 3;
    order.hidesBottomBarWhenPushed = YES;
    [self.owner.navigationController  pushViewController:order animated:YES];
}
// 已完成
- (IBAction)yiWanCheng:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.orderType = 4;
    order.hidesBottomBarWhenPushed = YES;
    [self.owner.navigationController  pushViewController:order animated:YES];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
