//
//  EaseUsersViewController.m
//  XZYS
//
//  Created by 杨利 on 16/10/9.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "EaseUsersViewController.h"

@interface EaseUsersViewController ()<EMContactManagerDelegate,EaseMessageViewControllerDataSource>
@end

@implementation EaseUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;   //是否支持下拉加载
    self.showTableBlankView = YES;   //是否显示无数据时默认背景
    self.title = @"客服列表";
   
    // Do any additional setup after loading the view.
    
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
