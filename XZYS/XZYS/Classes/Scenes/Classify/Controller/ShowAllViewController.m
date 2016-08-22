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
#import "OneTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface ShowAllViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

/// 搜索
@property (strong , nonatomic) UIImageView *searchIamgeView;
@property (nonatomic , strong) ShowAllDoubleView *rootView;
@property (nonatomic ,strong) NSMutableArray *allDataArray;
@property (nonatomic , strong) UIButton *MButton;
@property (nonatomic , copy) NSString *picStr;
@property (nonatomic , strong) UIView *cellView;
@property (nonatomic , strong) UITableView *mainTableView;
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
    _picStr = @"qh_01";
    self.cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 157)];

    [self.view addSubview:self.cellView];
    // Do any additional setup after loading the view from its nib.
    [self requestAllData];
    [self setNavigation];
    [self setCollectionView];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
}

- (void)setTableView {
    [self.rootView.collectionView removeFromSuperview];
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 149)];
    [self.mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OneTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.cellView addSubview:self.mainTableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SPXQModel *model = [[SPXQModel alloc] init];
    model = self.allDataArray[indexPath.row];
    cell.titleLabel.text = model.goods_name;
    
    NSString *str = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.goods_img];
    NSString *numStr = [NSString stringWithFormat:@"销量:%@件", model.sales_num];
    NSString *priceStr = [NSString stringWithFormat:@"￥%@", model.price];
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    cell.titleLabel.text = model.goods_name;
    cell.priceLabel.text = priceStr;
    cell.priceLabel.textColor = XZYSBlueColor;
    cell.numLabel.text = numStr;
    NSLog(@"%@", numStr);
    cell.numLabel.textColor = XZYSPinkColor;
    // Configure the cell...
    
    return cell;
}

- (void)setCollectionView {
    self.rootView = [[ShowAllDoubleView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    [self.cellView addSubview:self.rootView];
    // 设置代理
    self.rootView.collectionView.dataSource = self;
    self.rootView.collectionView.delegate = self;
    
    // 第一步：注册cell
    [self.rootView.collectionView registerClass:[RootCell class] forCellWithReuseIdentifier:identifier_cell];
}

- (void)setCollection {
    [self.mainTableView removeFromSuperview];
    self.rootView = [[ShowAllDoubleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 115)];
    [self.cellView addSubview:self.rootView];
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
    
    self.MButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.MButton.frame = CGRectMake(SCREEN_WIDTH - 32, 13, 20, 20);
    [self.MButton setImage:[UIImage imageNamed:_picStr] forState:UIControlStateNormal];
    
    [self.MButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:self.MButton];
    
    self.searchIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 5, SCREEN_WIDTH - 90, 34)];
    self.searchIamgeView.image = [UIImage imageNamed:@"index_04.png"];
    [backImageView addSubview:self.searchIamgeView];
    [self.view addSubview:backImageView];
    [self setTap];

    /// 添加选择按钮
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 36)];
    [self.view addSubview:pickBackView];
    UIButton *numButton = [UIButton buttonWithType:UIButtonTypeCustom];
    numButton.frame = CGRectMake(0, 0, SCREEN_WIDTH / 4, 36);
    [numButton setTitle:@"销 量" forState:UIControlStateNormal];
    numButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [numButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    [numButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:numButton];
    
    UIButton *priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton.frame = CGRectMake(SCREEN_WIDTH / 4, 0, SCREEN_WIDTH / 4, 36);
    [priceButton setTitle:@"价 格" forState:UIControlStateNormal];
    priceButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [priceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [priceButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    [priceButton addTarget:self action:@selector(priceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:priceButton];
    
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 4, 36);
    [timeButton setTitle:@"时 间" forState:UIControlStateNormal];
    [timeButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    timeButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [timeButton addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:timeButton];
    
    UIButton *sxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sxButton.frame = CGRectMake(SCREEN_WIDTH * 3 / 4, 0, SCREEN_WIDTH / 4, 36);
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


#pragma mark -  cell
- (void)cellButtonClick:(UIButton *)sender {
    if ([_picStr isEqualToString:@"qh_01"]) {
        [self.MButton setImage:[UIImage imageNamed:@"qh_02"] forState:UIControlStateNormal];
        _picStr = @"qh_02";
        [self setTableView];
        [self.mainTableView reloadData];
    } else if ([_picStr isEqualToString:@"qh_02"]) {
        [self.MButton setImage:[UIImage imageNamed:@"qh_01"] forState:UIControlStateNormal];
        _picStr = @"qh_01";
        [self setCollection];
        [self.rootView.collectionView reloadData];
    }

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
