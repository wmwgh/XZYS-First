//
//  RequestShouHouController.m
//  XZYS
//
//  Created by 杨利 on 16/9/11.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "RequestShouHouController.h"


@interface RequestShouHouController ()

@end

@implementation RequestShouHouController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请售后";
    NSLog(@"orderID::::%@", self.orderID);
    NSLog(@"goodsID::::%@", self.goodsID);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end