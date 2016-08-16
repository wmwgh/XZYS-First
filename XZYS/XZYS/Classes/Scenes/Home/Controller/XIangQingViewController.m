//
//  XIangQingViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/16.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "XIangQingViewController.h"
#import "Etalon.h"
#import "Goods.h"
#import "Deatais.h"

@interface XIangQingViewController ()

@end

@implementation XIangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    CGRect frame =CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);//如果没有导航栏，则去掉64
    
    //对应填写两个数组
    NSArray *views =@[[Goods new],[Deatais new],[Etalon new]];
    NSArray *names =@[@"商品",@"详情",@"规格"];
    //创建使用
    self.scroll =[XLScrollViewer scrollWithFrame:frame withViews:views withButtonNames:names withThreeAnimation:111];//三中动画都选择
    
    //自定义各种属性等等。。
    //    self.scroll.xl_topBackImage =[UIImage imageNamed:@"10.jpg"];
    //    self.scroll.xl_topBackColor =[UIColor yellowColor];
    //    self.scroll.xl_sliderColor =[UIColor blackColor];
    
    //加入控制器视图
    [self.view addSubview:self.scroll];
    
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
