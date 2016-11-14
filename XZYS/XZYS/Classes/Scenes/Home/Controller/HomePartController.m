//
//  HomePartController.m
//  XZYS
//
//  Created by 杨利 on 16/11/6.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "HomePartController.h"
#import "XZYS_Other.h"
#import "RootCell.h"
#import "ShowAllDoubleView.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "XIangQingViewController.h"

@interface HomePartController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic , strong) UILabel *lab;
/// 搜索
@property (strong, nonatomic) UITextField *searchText;
@property (nonatomic ,strong) NSMutableArray *allDataArray;
@property (nonatomic , strong) ShowAllDoubleView *rootView;
@property (nonatomic, assign) int page;
@property (nonatomic , copy) NSString *searchInID;
@end

@implementation HomePartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 2;
    // Do any additional setup after loading the view from its nib.
    //    [self requestData];
    [self setNavigation];
    //创建UICollectionView
    [self setCollectionView];
    // 添加顶部刷新
    [self addRefresh];
    
}

// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XIangQingViewController *XXVC = [[XIangQingViewController alloc] init];
    SDFQModel *model = [[SDFQModel alloc] init];
    model = self.allDataArray[indexPath.row];
    XXVC.model = model;
    XXVC.passID = model.goods_id;
    XXVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:XXVC animated:YES];
    
}

- (void)addRefresh {
    self.rootView.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.rootView.collectionView.mj_header.automaticallyChangeAlpha = YES;
    [self.rootView.collectionView.mj_header beginRefreshing];
    self.rootView.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.searchInID != nil && ![self.searchInID isEqualToString:@""]) {
        dic[@"search"] = self.searchInID;
    }
    dic[@"app_model_id"] = self.searchID;
    _allDataArray = [NSMutableArray array];
    [_allDataArray removeAllObjects];
    self.page = 2;
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Goods/goodsList" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([str isEqualToString:@"-101"]) {
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in dataArray) {
                SDFQModel *model = [[SDFQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.allDataArray addObject:model];
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            [self.rootView.collectionView reloadData];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        
        //结束刷新
        [self.rootView.collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)loadMoreData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.searchInID != nil && ![self.searchInID isEqualToString:@""]) {
        dic[@"search"] = self.searchInID;
    }
    dic[@"app_model_id"] = self.searchID;
    dic[@"page"] = [NSString stringWithFormat:@"%d", self.page];
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Goods/goodsList" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([str isEqualToString:@"-101"]) {
            self.page++;
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in dataArray) {
                SDFQModel *model = [[SDFQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.allDataArray addObject:model];
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            [self.rootView.collectionView reloadData];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"商品已全部更新";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        
        //结束刷新
        [self.rootView.collectionView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)setCollectionView {
    self.rootView = [[ShowAllDoubleView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 35)];
    [self.view addSubview:self.rootView];
    // 设置代理
    self.rootView.collectionView.dataSource = self;
    self.rootView.collectionView.delegate = self;
    
    // 第一步：注册cell
    [self.rootView.collectionView registerClass:[RootCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark UICollectionViewDataSource Method----

// 设置多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 设置每个分区里面有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allDataArray.count;
}

// 返回每一个item的cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 第二步：重用cell
    RootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.twoModel = self.allDataArray[indexPath.row];
    return cell;
}

#pragma mark - 界面区
- (void)setNavigation {
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    backImageView.image = [UIImage imageNamed:@"index_01.jpg"];
    backImageView.userInteractionEnabled = YES;
    
    UIButton *BButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BButton.frame = CGRectMake(5, 3, 30, 40);
    [BButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [BButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:BButton];
    
    
    self.searchText = [[UITextField alloc] initWithFrame:CGRectMake(45, 8, SCREEN_WIDTH - 60, 30)];
    self.searchText.placeholder = @"搜索...";
    self.searchText.backgroundColor = [UIColor whiteColor];
    [backImageView addSubview:self.searchText];
    self.searchText.textColor = [UIColor lightGrayColor];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(self.searchText.frame) - 30, 10, 30, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"zy_fdj"] forState:UIControlStateNormal];
    [backImageView addSubview:searchBtn];
    [self.view addSubview:backImageView];
}

- (void)search {
    self.searchInID = self.searchText.text;
    [self requestData];
}

- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
