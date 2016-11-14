//
//  LastXTViewController.m
//  XZYS
//
//  Created by 杨利 on 16/11/6.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "LastXTViewController.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"

@interface LastXTViewController ()

@end

@implementation LastXTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL ,self.model.img];
    [self.imaImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    self.titLab.text = self.model.title;
    self.noteLab.text = self.model.content;
    self.imaImageView.layer.cornerRadius = 10;
    self.imaImageView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
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
