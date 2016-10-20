//
//  ShouHouViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/24.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShouHouViewController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "ShouHouTableViewCell.h"
#import "ShouHouModel.h"
#import "ShouHouDetailViewController.h"
#import <MJRefresh.h>

@interface ShouHouViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic ,strong) NSMutableArray *allDataArray;
/** 页码*/
@property (nonatomic, assign) int page;

@end

@implementation ShouHouViewController
- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.title = @"售后区";
    [self setTab];
//    [self requestAllData];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shcallBack)
                                                 name:@"售后刷新UI"
                                               object:nil];
    // 添加顶部刷新
    [self addRefresh];
    // Do any additional setup after loading the view from its nib.
}

- (void)addRefresh {
    
    self.mainTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestAllData)];
    self.mainTab.mj_header.automaticallyChangeAlpha = YES;
    [self.mainTab.mj_header beginRefreshing];
    self.mainTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreDataShop)];
}

- (void)requestMoreDataShop {
    __weak typeof(self) weakSelf = self;
    self.page++;
    //请求参数
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = [NSString stringWithFormat:@"%d", self.page];
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/CustomerService/customerServiceList.html" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        if (![dataArray isEqual:@""]) {
            //获取数据源
            for (NSDictionary *dic in dataArray) {
                ShouHouModel *model = [[ShouHouModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.allDataArray addObject:model];
            }
        } else {
            //结束刷新
            [self.mainTab.mj_footer endRefreshing];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"商品已全部更新";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
        }
        [self.mainTab reloadData];
        [self.mainTab.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络异常，加载失败！";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }];
}

- (void)shcallBack{
    [self requestAllData];
}

- (void)setTab {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([ShouHouTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"scell"];
    self.mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTab.backgroundColor = [UIColor whiteColor];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    [self.view addSubview:self.mainTab];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShouHouModel *model = [[ShouHouModel alloc] init];
    model = self.allDataArray[indexPath.section];
    ShouHouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShouHouDetailViewController *thVC = [[ShouHouDetailViewController alloc] init];
    ShouHouModel *model = [[ShouHouModel alloc] init];
    model = self.allDataArray[indexPath.row];
    thVC.orderID = model.ID;
    [self.mainTab deselectRowAtIndexPath:indexPath animated:NO];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:thVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _allDataArray = [NSMutableArray array];
    [_allDataArray removeAllObjects];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/CustomerService/customerServiceList.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *order = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([order isEqualToString:@"-101"]) {
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in dataArray) {
                ShouHouModel *model = [[ShouHouModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.allDataArray addObject:model];
            }
        } else {
            UILabel *aview = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 50)];
            aview.text = @"暂无任何售后处理的商品";
            aview.textAlignment = NSTextAlignmentCenter;
            [self.mainTab addSubview:aview];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
        [self.mainTab reloadData];
        [self.mainTab.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
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
