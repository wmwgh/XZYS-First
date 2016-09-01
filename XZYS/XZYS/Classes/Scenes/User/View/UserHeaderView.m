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

@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 添加子视图
//        [self initLayout];
    }
    return self;
}

//- (void)initLayout {
//    self.nameLabel.text = @"qsdcnssnodvbojefnefqvosjbvsojvbojevbwe";
//}

// 修改个人信息
- (IBAction)changeMessage:(id)sender {
    NSLog(@"1");
    [self.owner.navigationController  pushViewController:[PassWordViewController new] animated:YES];
}
// 修改密码
- (IBAction)changePassWord:(id)sender {
    [self.owner.navigationController  pushViewController:[PassWordViewController new] animated:YES];

}
// 查看全部订单
- (IBAction)allDingDan:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.aaaa = 0;
    [self.owner.navigationController  pushViewController:order animated:YES];

}
// 待付款
- (IBAction)daiFukuan:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.aaaa = 1;
    [self.owner.navigationController  pushViewController:order animated:YES];

}
// 待收货
- (IBAction)daiShouHuo:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.aaaa = 2;
    [self.owner.navigationController  pushViewController:order animated:YES];

}
// 已支付
- (IBAction)yiZhiFu:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.aaaa = 3;
    [self.owner.navigationController  pushViewController:order animated:YES];

}
// 已完成
- (IBAction)yiWanCheng:(id)sender {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.aaaa = 4;
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
