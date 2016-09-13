//
//  SearchViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/11.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (nonatomic , strong) UILabel *lab;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 300, 300)];
    [self.view addSubview:_lab];
    self.lab.text = self.astr;
    self.lab.backgroundColor = [UIColor cyanColor];
    self.lab.font = [UIFont systemFontOfSize:50];
    NSLog(@"%@", self.lab.text);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
