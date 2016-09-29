//
//  ShouHouViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/24.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShouHouViewController.h"

@interface ShouHouViewController ()

@end

@implementation ShouHouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后区";
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 30)];
    lab.text = @"敬  请  期  待";
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
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
