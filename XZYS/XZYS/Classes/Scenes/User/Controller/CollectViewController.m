//
//  CollectViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/24.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "CollectViewController.h"
#import "XZYS_Other.h"
#import "HomeViewController.h"
#import "CollectGoodsViewCell.h"
#import "SonLislModel.h"
#import "ShopViewController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import "XIangQingViewController.h"
#import "CollectModel.h"
#import "CollectShopViewCell.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"
#import "XIangQingViewController.h"

static NSString *headerID = @"HeaderSectionID";

@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , assign) NSUInteger orderType;
@property (strong, nonatomic) IBOutlet UIView *underView1;
@property (strong, nonatomic) IBOutlet UIView *underView2;
@property (strong, nonatomic) IBOutlet UIButton *goodsButton;
@property (strong, nonatomic) IBOutlet UIButton *shopButton;
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic , strong) NSMutableArray *cellAllay;
@property (nonatomic , strong) NSMutableArray *shopAllay;
@property (nonatomic , strong) UIButton *titleButton;
@property (nonatomic , strong) UILabel *titLabel;
@property (nonatomic , strong) UIView *backView;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderType = 0;
    self.title = @"我的收藏";
    self.underView2.hidden = YES;
    [self.goodsButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self setTab];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(call1:)
                                                 name:@"bt1"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(call2:)
                                                 name:@"bt2"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(call3:)
                                                 name:@"bt3"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(call4:)
                                                 name:@"bt4"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(call5:)
                                                 name:@"bt5"
                                               object:nil];
    [self setnullView];
    // Do any additional setup after loading the view from its nib.
}
- (void)call1:(NSNotification *)text {
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    xxVC.passID = text.userInfo[@"sid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
- (void)call2:(NSNotification *)text {
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    xxVC.passID = text.userInfo[@"sid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
- (void)call3:(NSNotification *)text {
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    xxVC.passID = text.userInfo[@"sid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
- (void)call4:(NSNotification *)text {
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    xxVC.passID = text.userInfo[@"sid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
- (void)call5:(NSNotification *)text {
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    xxVC.passID = text.userInfo[@"sid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)requestData {
    self.orderType = 0;
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    __weak typeof(self) weakSelf = self;
    weakSelf.cellAllay = [NSMutableArray array];
    [weakSelf.cellAllay removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/getCollectGoodsList" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
            for (NSDictionary *dic in dataArray) {
                SonLislModel *model = [[SonLislModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.cellAllay addObject:model];
            }
            // 隐藏指示器
            [SVProgressHUD dismiss];
            [weakSelf.mainTab reloadData];
            [self.backView removeFromSuperview];
        } else {
            [self setNullView];
            [weakSelf.mainTab reloadData];
            // 隐藏指示器
            [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];

}

- (void)requestShop {
    self.orderType = 1;
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    __weak typeof(self) weakSelf = self;
    weakSelf.cellAllay = [NSMutableArray array];
    [weakSelf.cellAllay removeAllObjects];
    weakSelf.shopAllay = [NSMutableArray array];
    [weakSelf.shopAllay removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/getCollectShopList" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        NSMutableArray *array = [NSMutableArray array];
        if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
            for (NSDictionary *dic in dataArray) {
                CollectModel *model = [[CollectModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.cellAllay addObject:model];
                NSArray *arr = dic[@"goods_list"];
                for (NSDictionary *dic1 in arr) {
                    CollectModel *model1 = [[CollectModel alloc] init];
                    [model1 setValuesForKeysWithDictionary:dic1];
                    [array addObject:model1];
                }
                [self.shopAllay addObject:array];
            }
            // 隐藏指示器
            [SVProgressHUD dismiss];
            [weakSelf.mainTab reloadData];
            [self.backView removeFromSuperview];
        } else {
            [self setNullView];
            [weakSelf.mainTab reloadData];
            // 隐藏指示器
            [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
}
- (void)setnullView {
    self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, SCREEN_WIDTH - 100, 20)];
    lab.text = @"您 还 没 有 收 藏";
    lab.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:lab];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 130, 300, 120, 30);
    [backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [backButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.backView addSubview:backButton];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIButton *backButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton2.frame = CGRectMake(SCREEN_WIDTH / 2 + 10, 300, 120, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"sc_bj"] forState:UIControlStateNormal];
    [backButton2 setBackgroundImage:[UIImage imageNamed:@"sc_bj"] forState:UIControlStateNormal];
    [backButton2 setTitle:@"去爆款区看看" forState:UIControlStateNormal];
    [backButton2 setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    backButton2.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.backView addSubview:backButton2];
    [backButton2 addTarget:self action:@selector(backAction1) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setNullView {
    [self.mainTab addSubview:self.backView];
}

- (void)backAction {
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    self.tabBarController.selectedIndex = 0;
    [self.tabBarController.navigationController pushViewController:homeVC animated:YES];
}

- (void)backAction1 {
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    self.tabBarController.selectedIndex = 0;
    [self.tabBarController.navigationController pushViewController:homeVC animated:YES];
}

- (void)setTab {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, SCREEN_HEIGHT - 115) style:UITableViewStyleGrouped];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    self.mainTab.backgroundColor = XZYSRGBColor(230, 230, 230);
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([CollectGoodsViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([CollectShopViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:self.mainTab];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellAllay.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderType == 0) {
        SonLislModel *model = [[SonLislModel alloc] init];
        model = self.cellAllay[indexPath.section];
        CollectGoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    } else if (self.orderType == 1){
        CollectModel *model = [[CollectModel alloc] init];
        NSArray *ar = self.shopAllay[indexPath.section];
        CollectShopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        model = ar[0];
        cell.tittle1.text = model.goods_name;
        cell.price1.text = [NSString stringWithFormat:@"￥%@", model.price];
        [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.goods_img]]];
        cell.bt1.tag = [model.goods_id intValue];
        model = ar[1];
        cell.tittle2.text = model.goods_name;
        cell.price2.text = [NSString stringWithFormat:@"￥%@", model.price];
        [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.goods_img]]];
        cell.bt2.tag = [model.goods_id intValue];
        model = ar[2];
        cell.tittle3.text = model.goods_name;
        cell.price3.text = [NSString stringWithFormat:@"￥%@", model.price];
        [cell.img3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.goods_img]]];
        cell.bt3.tag = [model.goods_id intValue];
        model = ar[3];
        cell.tittle4.text = model.goods_name;
        cell.price4.text = [NSString stringWithFormat:@"￥%@", model.price];
        [cell.img4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.goods_img]]];
        cell.bt4.tag = [model.goods_id intValue];
        model = ar[4];
        cell.tittle5.text = model.goods_name;
        cell.price5.text = [NSString stringWithFormat:@"￥%@", model.price];
        [cell.img5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.goods_img]]];
        cell.bt5.tag = [model.goods_id intValue];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderType == 0) {
        return 89;
    } else if (self.orderType == 1) {
        return 105;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.orderType == 0) {
        return 40;
    } else if (self.orderType == 1) {
        return 60;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    if (self.orderType == 0) {
        SonLislModel *model = self.cellAllay[indexPath.row];
        xxVC.passID = model.goods_id;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:xxVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    } else if (self.orderType == 1) {

    }
    [self.mainTab deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
    UIView *backView = [[UIView alloc] init];
    
    backView.backgroundColor = XZYSRGBColor(244, 241, 242);
    [headerView addSubview:backView];
    UIImageView *dpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 25, 25)];
    dpImage.image = [UIImage imageNamed:@"dp_sd"];
    [backView addSubview:dpImage];
    
    self.titLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 145, 40)];
    self.titLabel.font = [UIFont systemFontOfSize:14];
    [backView bringSubviewToFront:self.titLabel];
    [backView addSubview:self.titLabel];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(45, 0, SCREEN_WIDTH - 140, 40);
    [self.titleButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(titleBT:) forControlEvents:UIControlEventTouchUpInside];
    self.titleButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [backView addSubview:self.titleButton];
    
    UIImageView *jianimage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titLabel.frame), 12, 15, 17)];
    jianimage.image = [UIImage imageNamed:@"dp_ht"];
    [backView addSubview:jianimage];
    
    if (self.orderType == 0) {
        backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        SonLislModel *model = [[SonLislModel alloc] init];
        model = self.cellAllay[section];
        self.titLabel.text = model.shop_name;
        self.titleButton.tag = [model.shop_id intValue];
    } else if (self.orderType == 1) {
        backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 36, 40, 17)];
        lab1.text = @"收藏数:";
        lab1.textColor = [UIColor darkGrayColor];
        lab1.font = [UIFont systemFontOfSize:11];
        [backView addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 36, 40, 17)];
        lab2.textColor = [UIColor darkGrayColor];
        lab2.font = [UIFont systemFontOfSize:11];
        [backView addSubview:lab2];
        
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(135, 36, 28, 17)];
        lab3.text = @"销量:";
        lab3.textColor = [UIColor darkGrayColor];
        lab3.font = [UIFont systemFontOfSize:11];
        [backView addSubview:lab3];
        
        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(163, 36, 40, 17)];
        lab4.textColor = [UIColor darkGrayColor];
        lab4.font = [UIFont systemFontOfSize:11];
        [backView addSubview:lab4];
        
        UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(213, 36, 40, 17)];
        lab5.text = @"宝贝数:";
        lab5.textColor = [UIColor darkGrayColor];
        lab5.font = [UIFont systemFontOfSize:11];
        [backView addSubview:lab5];
        
        UILabel *lab6 = [[UILabel alloc] initWithFrame:CGRectMake(253, 36, 40, 17)];
        lab6.textColor = [UIColor darkGrayColor];
        lab6.font = [UIFont systemFontOfSize:11];
        [backView addSubview:lab6];
        
        CollectModel *model = [[CollectModel alloc] init];
        model = self.cellAllay[section];
        self.titLabel.text = model.shop_name;
        self.titleButton.tag = [model.ID intValue];
        lab4.text = model.sales_num;
        lab6.text = model.goods_num;
        lab2.text = model.collect_num;
    }
    
    return headerView;
}
- (void)titleBT:(UIButton *)sender {
    ShopViewController *shopVC = [[ShopViewController alloc] init];
    shopVC.shopID = [NSString stringWithFormat:@"%ld", sender.tag];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;

}

- (IBAction)goodsCollect:(id)sender {
    self.underView1.hidden = NO;
    self.underView2.hidden = YES;
    [self.goodsButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.shopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self requestData];
}

- (IBAction)shopCollect:(id)sender {
    self.underView1.hidden = YES;
    self.underView2.hidden = NO;
    [self.goodsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shopButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self requestShop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (self.orderType == 0) {
        [self requestData];
    } else if (self.orderType == 1) {
        [self requestShop];
    }
    
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
