//
//  ShowAllViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/13.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShowAllViewController.h"
#import "XZYS_Other.h"
#import "SearchViewController.h"
#import "RootCell.h"
#import "ShowAllDoubleView.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"
#import "SPXQModel.h"
#import <SVProgressHUD.h>


@interface ShowAllViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/// 搜索
@property (strong, nonatomic) UIImageView *searchIamgeView;
@property (nonatomic, strong) ShowAllDoubleView *rootView;
@property (nonatomic ,strong) NSMutableArray *allDataArray;
//@property (nonatomic ,strong) NSMutableArray *priceArray;
//@property (nonatomic ,strong) NSMutableArray *zhuanchengArray;
//@property (nonatomic ,strong) NSMutableArray *zhuanquArray;
//@property (nonatomic ,strong) NSMutableArray *caizhiArray;
//@property (nonatomic ,strong) NSMutableArray *neiliArray;
//@property (nonatomic ,strong) NSMutableArray *xiegeArray;
//@property (nonatomic ,strong) NSMutableArray *allDataArray;
//@property (nonatomic ,strong) NSMutableArray *allDataArray;
//@property (nonatomic ,strong) NSMutableArray *allDataArray;

@end

@implementation ShowAllViewController
static NSString *const identifier_cell = @"identifier_cell";

- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestAllData];
    [self setCollection];
    [self setNavigation];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
}

- (void)setCollection {
    self.rootView = [[ShowAllDoubleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.rootView;
    // 设置代理
    self.rootView.collectionView.dataSource = self;
    self.rootView.collectionView.delegate = self;
    
    // 第一步：注册cell
    [self.rootView.collectionView registerClass:[RootCell class] forCellWithReuseIdentifier:identifier_cell];

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
    RootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_cell forIndexPath:indexPath];
    cell.oneModel = self.allDataArray[indexPath.row];
    return cell;
}

#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    _allDataArray = [NSMutableArray array];
    [_allDataArray removeAllObjects];
    [[AFHTTPSessionManager manager] GET:XZYSALL__URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
       
        for (NSDictionary *dic in dataArray) {
            SPXQModel *model = [[SPXQModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.allDataArray addObject:model];
        }
        
        
        [self.rootView.collectionView reloadData];
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
}

- (void)setNavigation {
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    backImageView.image = [UIImage imageNamed:@"index_01.jpg"];
    backImageView.userInteractionEnabled = YES;
    
    UIButton *BButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BButton.frame = CGRectMake(5, 4, 30, 40);
    [BButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [BButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:BButton];
    
    UIButton *MButton = [UIButton buttonWithType:UIButtonTypeCustom];
    MButton.frame = CGRectMake(SCREEN_WIDTH - 32, 13, 20, 20);
    [MButton setImage:[UIImage imageNamed:@"qh_01"] forState:UIControlStateNormal];
    [MButton setImage:[UIImage imageNamed:@"qh_02"] forState:UIControlStateSelected];
    [MButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:MButton];
    
    self.searchIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 5, SCREEN_WIDTH - 90, 34)];
    self.searchIamgeView.image = [UIImage imageNamed:@"index_04.png"];
    [backImageView addSubview:self.searchIamgeView];
    [self.view addSubview:backImageView];
    [self setTap];

    /// 添加选择按钮
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    pickBackView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:pickBackView];
    UIButton *numButton = [UIButton buttonWithType:UIButtonTypeCustom];
    numButton.frame = CGRectMake(0, 0, SCREEN_WIDTH / 4, 44);
    [numButton setTitle:@"销 量" forState:UIControlStateNormal];
    numButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [numButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    [numButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:numButton];
    
    UIButton *priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton.frame = CGRectMake(SCREEN_WIDTH / 4, 0, SCREEN_WIDTH / 4, 44);
    [priceButton setTitle:@"价 格" forState:UIControlStateNormal];
    priceButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [priceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [priceButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    [priceButton addTarget:self action:@selector(priceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:priceButton];
    
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 4, 44);
    [timeButton setTitle:@"时 间" forState:UIControlStateNormal];
    [timeButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    timeButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [timeButton addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:timeButton];
    
    UIButton *sxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sxButton.frame = CGRectMake(SCREEN_WIDTH * 3 / 4, 0, SCREEN_WIDTH / 4, 44);
    [sxButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    sxButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [sxButton setTitle:@"筛 选" forState:UIControlStateNormal];
    [sxButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sxButton addTarget:self action:@selector(sxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:sxButton];
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
    
}

- (void)numButtonClick:(UIButton *)sender {
    
}
- (void)priceButtonClick:(UIButton *)sender {
    
}
- (void)timeButtonClick:(UIButton *)sender {
    
}
- (void)sxButtonClick:(UIButton *)sender {
    
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
