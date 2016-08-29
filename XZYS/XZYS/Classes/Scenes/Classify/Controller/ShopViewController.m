//
//  ShopViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/27.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShopViewController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "XZYS_Other.h"
#import "XZYS_URL.h"
#import <SVProgressHUD.h>
#import "ShopModel.h"
#import "ShopView.h"
#import "RootCell.h"
#import "ShopHeaderView.h"
#import "XiTongViewController.h"
#import "SearchViewController.h"
#import "SDFQModel.h"

static NSString *const identifier_cell = @"identifier_cell";
static NSString *const firatID = @"firstHeader";//图和字和线
@interface ShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *MButton;
}
/// 搜索
@property (strong, nonatomic) UIImageView *searchIamgeView;
@property (nonatomic , strong) ShopView *rootView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *collectionArray;
@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"店铺";
    // 请求数据
    [self requestData];
    [self setCollection];
    [self setNavigation];

}

- (void)setCollection {
    self.rootView = [[ShopView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT- 44)];
    [self.view addSubview:self.rootView];
    // 设置代理
    self.rootView.collectionView.dataSource = self;
    self.rootView.collectionView.delegate = self;
    
    // 第一步：注册cell
    [self.rootView.collectionView registerClass:[RootCell class] forCellWithReuseIdentifier:identifier_cell];
    
    // 注册头视图
    [self.rootView.collectionView registerNib:[UINib nibWithNibName:@"ShopHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:firatID];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ShopHeaderView *hview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:firatID forIndexPath:indexPath];
        
        hview.backgroundColor = [UIColor orangeColor];
        return hview;
    }
    return nil;
}


- (void)requestData {
    __weak typeof(self) weakSelf = self;
    [weakSelf.dataArray removeAllObjects];
    weakSelf.dataArray = [NSMutableArray array];
    [weakSelf.collectionArray removeAllObjects];
    weakSelf.collectionArray = [NSMutableArray array];
    
    
    if (weakSelf.shopID != nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_DP_URL, weakSelf.shopID];
        NSLog(@"%@", weakSelf.shopID);
        [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            NSDictionary *dataDic = responseObject[@"data"];
            ShopModel *model = [[ShopModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            [weakSelf.dataArray addObject:model];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            // 显示加载错误信息
            [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
            NSLog(@"%@", error);
        }];
        
        
        /// collection 数据请求
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:weakSelf.shopID forKey:@"shop_id"];
        
        [[AFHTTPSessionManager manager] GET:XZYS_ALL_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            NSArray *dataArr = responseObject[@"data"];
            
            for (NSDictionary *dic in dataArr) {
                SDFQModel *model = [[SDFQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.collectionArray addObject:model];
            }
            [self.rootView.collectionView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            // 显示加载错误信息
            [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
            NSLog(@"%@", error);
        }];
        
        
        
    } else {
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"无法找到该店铺"];
    }

    
}


#pragma mark UICollectionViewDataSource Method----

// 设置多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 设置每个分区里面有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.collectionArray.count;
}

// 返回每一个item的cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 第二步：重用cell
    RootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_cell forIndexPath:indexPath];
    cell.oneModel = self.collectionArray[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面区
- (void)setNavigation {
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    backImageView.image = [UIImage imageNamed:@"index_01.jpg"];
    backImageView.userInteractionEnabled = YES;
    
    UIButton *BButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BButton.frame = CGRectMake(5, 4, 30, 40);
    [BButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [BButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:BButton];
    
    MButton = [UIButton buttonWithType:UIButtonTypeCustom];
    MButton.frame = CGRectMake(SCREEN_WIDTH - 32, 13, 20, 20);
    [MButton setImage:[UIImage imageNamed:@"index_10.png"] forState:UIControlStateNormal];
    [MButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:MButton];
    
    self.searchIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 5, SCREEN_WIDTH - 90, 34)];
    self.searchIamgeView.image = [UIImage imageNamed:@"index_04.png"];
    [backImageView addSubview:self.searchIamgeView];
    [self.view addSubview:backImageView];
    [self setTap];
}

#pragma mark --- 手势设置

- (void)setTap {
    //设置搜索单击手势
    [self.searchIamgeView setUserInteractionEnabled:YES];
    [self.searchIamgeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapClick:)]];
    
}

// 搜索
- (void)searchTapClick:(UITapGestureRecognizer *)sender {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -  消息
- (void)messageButtonClick:(UIButton *)sender {
    MButton.selected = !MButton.selected;
    XiTongViewController *messageVC = [[XiTongViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
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
