//
//  UserProViewController.m
//  XZYS
//
//  Created by 杨利 on 16/10/20.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "UserProViewController.h"

@interface UserProViewController ()

@end

@implementation UserProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:webView];
    NSURL* url = [NSURL URLWithString:self.urlType];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
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
