//
//  YiJianViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/30.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "YiJianViewController.h"

@interface YiJianViewController ()

@end

@implementation YiJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    // Do any additional setup after loading the view from its nib.
    self.complateButton.layer.cornerRadius = 5;
    self.yjtextView.layer.cornerRadius = 5;
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
