//
//  TiaoHuoViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/24.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "TiaoHuoViewController.h"
#import "RootCell.h"
#import "ShowAllDoubleView.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"
#import <SVProgressHUD.h>



@interface TiaoHuoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) ShowAllDoubleView *rootView;
@property (nonatomic ,strong) NSMutableArray *allDataArray;
@property (nonatomic , strong) NSMutableDictionary *param;


@end

@implementation TiaoHuoViewController

- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调货区";
    [self setCollectionView];
//    [self requestAllData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setCollectionView {
    self.rootView = [[ShowAllDoubleView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}
#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    _allDataArray = [NSMutableArray array];
    [_allDataArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/DispatchGoods/dispatchGoodsList.html" parameters:weakSelf.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
            
            for (NSDictionary *dic in dataArray) {
                SDFQModel *model = [[SDFQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.allDataArray addObject:model];
            }
            [self.rootView.collectionView reloadData];
            // 隐藏指示器
            [SVProgressHUD dismiss];
        } else {
            NSLog(@"12341失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
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
