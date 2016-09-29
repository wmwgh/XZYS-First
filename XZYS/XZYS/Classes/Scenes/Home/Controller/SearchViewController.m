//
//  SearchViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/11.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "SearchViewController.h"
#import "XZYS_Other.h"
#import "RootCell.h"
#import "ShowAllDoubleView.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic , strong) UILabel *lab;
/// 搜索
@property (strong, nonatomic) UITextField *searchText;
@property (nonatomic ,strong) NSMutableArray *allDataArray;
@property (nonatomic , strong) ShowAllDoubleView *rootView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestData];
    [self setNavigation];
    //创建UICollectionView
    [self setCollectionView];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"search"] = self.searchID;
    _allDataArray = [NSMutableArray array];
    [_allDataArray removeAllObjects];
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
            [hud hide:YES afterDelay:1.5];
        }
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
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
    self.searchID = self.searchText.text;
    [self requestData];
}

- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
