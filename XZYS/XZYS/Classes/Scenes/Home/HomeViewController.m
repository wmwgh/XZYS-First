//
//  HomeViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "HomeViewController.h"
#import "XZYS_Other.h"
#import "XZYS_URL.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "LBTModel.h"
#import "SDZCModel.h"
#import "SDFQModel.h"
#import "XiTongViewController.h"
#import "ScanningViewController.h"
#import "FzhScrollViewAndPageView.h"
#import "SearchViewController.h"
#import "FirstHeaderReusableView.h"
#import "HeaderReusableView.h"
#import "RootCell.h"
#import "RootView.h"
#import "XIangQingViewController.h"
#import "ClassifyViewController.h"
#import "UserViewController.h"
#import "OrderListViewController.h"
#import "TiaoHuoViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ShowAllViewController.h"
#import "TiaoHuoDetailController.h"
#import "SonLislModel.h"
#import "HomePartController.h"

@interface HomeViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,FzhScrollViewDelegate>
/// 搜索
@property (strong, nonatomic) UITextField *searchText;
@property (nonatomic , strong) UIView *redView;
@property (nonatomic , copy) NSString *dataID;
// 主头视图
@property (nonatomic, strong) UIView *headerBackView;
@property (nonatomic , strong) UIView *backView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *mypageControl;

/// 三大区的图片
@property (nonatomic, strong) NSMutableArray *SDQArray;
/// 轮播图图片
@property (nonatomic, strong) NSMutableArray *LBTArray;
/// 商品图片
@property (nonatomic, strong) NSMutableArray *SPTArray;
/// 商品标题
@property (nonatomic, strong) NSMutableArray *SPTTittleArray;
/// 轮播图
@property (nonatomic, strong) FzhScrollViewAndPageView *fzhView;
/// 搜索手势
@property (nonatomic, strong) UITapGestureRecognizer *searchTap;
@property (nonatomic, strong) RootView *rootView;
@property (nonatomic, strong) NSMutableArray *THQdataArray;
@end

@implementation HomeViewController

- (NSMutableArray *)SDQArray {
    
    if (!_SDQArray) {
        _SDQArray = [NSMutableArray array];
    }
    return _SDQArray;
}

- (NSMutableArray *)THQdataArray {
    
    if (!_THQdataArray) {
        _THQdataArray = [NSMutableArray array];
    }
    return _THQdataArray;
}

- (NSMutableArray *)LBTArray {
    
    if (!_LBTArray) {
        _LBTArray = [NSMutableArray array];
    }
    return _LBTArray;
}

- (NSMutableArray *)SPTArray {
    
    if (!_SPTArray) {
        _SPTArray = [NSMutableArray array];
    }
    return _SPTArray;
}

- (NSMutableArray *)SPTTittleArray {
    
    if (!_SPTTittleArray) {
        _SPTTittleArray = [NSMutableArray array];
    }
    return _SPTTittleArray;
}

// 定义全局的重用标识符
static NSString *const identifier_cell = @"identifier_cell";
static NSString *const firatID = @"firstHeader";//图和字和线
static NSString *const secondID = @"secondHeader";//字和线


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
//    self.tabBarController.selectedIndex = 0;
    self.navigationController.navigationBarHidden = YES;
    self.headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 408)];
    // 请求数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestData];
    });
    [self setCollection];

    // 导航栏
    [self setNavigation];
    // 添加顶部刷新
    [self addRefresh];
    // 按钮
    [self fourButton];
    [self setReadView];
    // 显示指示器
//    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    // 通知中心
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(oneClick)
//                                                 name:@"onebtnclick"            object:nil];
}


- (void)setCollection {
    self.rootView = [[RootView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.rootView;
    // 设置代理
    self.rootView.collectionView.dataSource = self;
    self.rootView.collectionView.delegate = self;
    
    // 第一步：注册cell
    [self.rootView.collectionView registerClass:[RootCell class] forCellWithReuseIdentifier:identifier_cell];
    
    // 注册头视图
    [self.rootView.collectionView registerClass:[FirstHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:firatID];
    
    [self.rootView.collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:secondID];
    
    // 注册尾视图
    [self.rootView.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
}

#pragma mark - 四大区数据
- (void)requesdCollectionData {
    __weak typeof(self) weakSelf = self;
    [weakSelf.SPTArray removeAllObjects];
    [weakSelf.SPTTittleArray removeAllObjects];
    [[AFHTTPSessionManager manager] GET:XZYS_SDQ_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        NSArray *dataArray = responseObject[@"data"];
        if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
            NSString *titStr = nil;
            for (NSDictionary *dicty in dataArray) {
                NSMutableArray *arr = [NSMutableArray array];
                NSArray *dataar = dicty[@"goods_list"];
                if (dataar != nil && ![dataar isKindOfClass:[NSNull class]] && dataar.count != 0) {
                    titStr = dicty[@"name"];
                    for (NSDictionary *dic in dataar) {
                        SDFQModel *model = [[SDFQModel alloc] init];
                        [model setValuesForKeysWithDictionary:dic];
                        [arr addObject:model];
                    }
                    [weakSelf.SPTArray addObject:arr];
                    [weakSelf.SPTTittleArray addObject:titStr];
                }
            }
        } else {
        }// 请求调货区数据
        [self requestTHQData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];

    
}

- (void)requestTHQData {
    __weak typeof(self) weakSelf = self;
    [weakSelf.THQdataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    [[AFHTTPSessionManager manager] POST:XZYS_THQ_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *order = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        NSMutableArray *Arra = [NSMutableArray array];
        if ([order isEqualToString:@"-101"]) {
            NSString  *titStr = @"调货区";
            [weakSelf.SPTTittleArray addObject:titStr];
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in dataArray) {
                SDFQModel *model = [[SDFQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [Arra addObject:model];
                [self.THQdataArray addObject:model];
            }
            [weakSelf.SPTArray addObject:Arra];
        }
        
        // 请求成功，解析数据
//        NSDictionary *dataDic = responseObject[@"data"];
//        NSArray *dataArray = dataDic[@"goods_list"];
//        if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
//            NSString *titStr = nil;
//            titStr = dataDic[@"name"];
//            [weakSelf.SPTTittleArray addObject:titStr];
//            NSMutableArray *arr = [NSMutableArray array];
//            if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
//                for (NSDictionary *dic in dataArray) {
//                    SDFQModel *model = [[SDFQModel alloc] init];
//                    [model setValuesForKeysWithDictionary:dic];
//                    [arr addObject:model];
//                    [self.THQdataArray addObject:model];
//                }
//                [weakSelf.SPTArray addObject:arr];
//            }
//        } else {
//        }
        [self.rootView.collectionView.mj_header endRefreshing];
        [self.rootView.collectionView reloadData];
        // 隐藏指示器
//        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

#pragma mark UICollectionViewDataSource Method----

// 设置多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.SPTTittleArray.count;
}

// 设置每个分区里面有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    if (section == 0) {
        NSArray *itemArr = self.SPTArray[0];
        return itemArr.count;
        }
    
    if (section == 1) {
        NSArray *itemArr = self.SPTArray[1];
        return itemArr.count;
        }
    
    if (section == 2) {
        if (self.SPTArray[2] != nil) {
            NSArray *itemArr = self.SPTArray[2];
            return itemArr.count;
        }
    }
    if (section == 3) {
        if (self.SPTArray[3] != nil) {
            NSArray *itemArr = self.SPTArray[3];
            return itemArr.count;
        }
    }
    return 0;
}

// 返回每一个item的cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 第二步：重用cell
    RootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_cell forIndexPath:indexPath];
    
    NSArray *modelArray = self.SPTArray[indexPath.section];
    cell.oneModel = modelArray[indexPath.row];
    return cell;
}

// 返回头视图和尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // 判断是头视图还是尾视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0){
            NSString *str = self.SPTTittleArray[0];
            FirstHeaderReusableView *firstHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:firatID forIndexPath:indexPath];
            [firstHeaderView.oneBtn addTarget:self action:@selector(oneClick) forControlEvents:UIControlEventTouchUpInside];
            firstHeaderView.oneBtn.tag = 121;
            // 布局头视图尺寸
            self.rootView.myFlowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*2.7 / 3.1 + 165);
            [firstHeaderView addSubview:self.headerBackView];
            firstHeaderView.headerLabel.text = str;
            [self.rootView.collectionView bringSubviewToFront:firstHeaderView];
            return firstHeaderView;
        }
        
        HeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:secondID forIndexPath:indexPath];
        [headerView.asdBtn addTarget:self action:@selector(bkqAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 布局头视图尺寸
        self.rootView.myFlowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 55);
        if (indexPath.section == 1){
            NSString *str = self.SPTTittleArray[1];
            headerView.headerLabel.text = str;
            headerView.asdBtn.tag = 122;
            return headerView;
        }
        
        if (indexPath.section == 2){
            NSString *str = self.SPTTittleArray[2];
            headerView.headerLabel.text = str;
            if ([str isEqualToString:@"调货区"]) {
                headerView.asdBtn.tag = 124;
            } else {
                headerView.asdBtn.tag = 123;
            }
            return headerView;
        }
        
        if (indexPath.section == 3){
            NSString *str = self.SPTTittleArray[3];
            headerView.headerLabel.text = str;
            if ([str isEqualToString:@"调货区"]) {
                headerView.asdBtn.tag = 124;
            } else {
                headerView.asdBtn.tag = 123;
            }
            return headerView;
        }
        return headerView;
    }
    return nil;
}

- (void)oneClick {
    HomePartController *searchVC = [[HomePartController alloc] init];
    searchVC.searchID = @"1";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)bkqAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    NSLog(@"%@", str);
    if ([str isEqualToString:@"122"]) {
        HomePartController *searchVC = [[HomePartController alloc] init];
        searchVC.searchID = @"2";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if ([str isEqualToString:@"123"]) {
        HomePartController *searchVC = [[HomePartController alloc] init];
        searchVC.searchID = @"3";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if ([str isEqualToString:@"124"]) {
        TiaoHuoViewController *thVC = [[TiaoHuoViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:thVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}

// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int indexId = 0;
    int typeId = 0;
    for (int i = 0; i < self.SPTTittleArray.count; i++) {
        NSString *name = self.SPTTittleArray[i];
        if ([name isEqualToString:@"调货区"]) {
            indexId = i;
            typeId = 1;
        }
    }
    if (typeId == 1) {
        if (indexPath.section == indexId) {
            TiaoHuoDetailController *thVC = [[TiaoHuoDetailController alloc] init];
            SonLislModel *model = [[SonLislModel alloc] init];
            model = self.THQdataArray[indexPath.row];
            thVC.orderID = model.ID;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:thVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } else if (indexPath.section != indexId) {
            XIangQingViewController *XXVC = [[XIangQingViewController alloc] init];
            NSArray *ar = self.SPTArray[indexPath.section];
            SDFQModel *model = [[SDFQModel alloc] init];
            model = ar[indexPath.row];
            XXVC.model = model;
            XXVC.passID = model.goods_id;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:XXVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    } else {
        XIangQingViewController *XXVC = [[XIangQingViewController alloc] init];
        NSArray *ar = self.SPTArray[indexPath.section];
        SDFQModel *model = [[SDFQModel alloc] init];
        model = ar[indexPath.row];
        XXVC.model = model;
        XXVC.passID = model.goods_id;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:XXVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)setNavigation {
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    backImageView.image = [UIImage imageNamed:@"index_01.jpg"];
    backImageView.userInteractionEnabled = YES;
    
    UIButton *SButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SButton.frame = CGRectMake(10, 13, 25, 25);
    [SButton setImage:[UIImage imageNamed:@"index_07.png"] forState:UIControlStateNormal];
    [SButton addTarget:self action:@selector(saoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:SButton];
    
    UIButton *MButton = [UIButton buttonWithType:UIButtonTypeCustom];
    MButton.frame = CGRectMake(SCREEN_WIDTH - 37, 13, 28, 25);
    [MButton setImage:[UIImage imageNamed:@"index_10.png"] forState:UIControlStateNormal];
    [MButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:MButton];
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 13, 11, 6, 6)];
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.layer.cornerRadius = 3;
    self.redView.hidden = YES;
    [backImageView addSubview:self.redView];
    self.searchText = [[UITextField alloc] initWithFrame:CGRectMake(45, 10, SCREEN_WIDTH - 90, 30)];
    self.searchText.placeholder = @"搜索...";
    self.searchText.textColor = [UIColor lightGrayColor];
    self.searchText.backgroundColor = [UIColor whiteColor];
    [backImageView addSubview:self.searchText];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(self.searchText.frame) - 30, 10, 30, 30);
    [searchBtn addTarget:self action:@selector(searchGoods) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"zy_fdj"] forState:UIControlStateNormal];
    [backImageView addSubview:searchBtn];
    [self.view addSubview:backImageView];
    
}

- (void)searchGoods {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.searchID = self.searchText.text;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -  扫一扫
- (void)saoButtonClick:(UIButton *)sender {
    ScanningViewController * sVC = [[ScanningViewController alloc]init];
    sVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sVC animated:YES];
}

#pragma mark -  消息
- (void)messageButtonClick:(UIButton *)sender {
    XiTongViewController *messageVC = [[XiTongViewController alloc] init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark --- 轮播图
- (void)LBTView {
    // 创建view（view中包含UIScrollView、UIPageControl，设置frame）
    _fzhView = [[FzhScrollViewAndPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 2.1)];
    // 把n张图片放到imageView上
    NSMutableArray *tempAry = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",i]];
        LBTModel *model = [[LBTModel alloc] init];
        model = self.LBTArray[i];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.img];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        [tempAry addObject:imageView];
    }
    
    // 把imageView数组存到fzhView里
    [_fzhView setImageViewAry:tempAry];
    // 开启自动翻页
    [_fzhView shouldAutoShow:YES];
    // 遵守协议
    _fzhView.delegate = self;
    // 把图片展示的view加到当前页面
    [self.headerBackView addSubview:self.fzhView];
}

#pragma mark --- 协议里面方法，点击某一页
-(void)didClickPage:(FzhScrollViewAndPageView *)view atIndex:(NSInteger)index
{
//    NSLog(@"点击了第%ld页",index);
}

- (void)addRefresh {
    self.dataID = @"12";
    self.rootView.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requesdCollectionData)];
    self.rootView.collectionView.mj_header.automaticallyChangeAlpha = YES;
    [self.rootView.collectionView.mj_header beginRefreshing];
}



- (void)setReadView {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *ar = @[@"0", @"1", @"2"];
    params[@"uid"] = appDelegate.userIdTag;
    for (int i = 0; i < ar.count; i++) {
        params[@"status"] = ar[i];
        [manager POST:@"http://www.xiezhongyunshang.com/App/Msg/getMsgUnreadNum" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *str = responseObject[@"data"];
            if ([str isEqualToString:@"0"]) {
                self.redView.hidden = YES;
            } else {
                self.redView.hidden = NO;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}
#pragma mark - 三大专区数据
// 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;
    
    [[AFHTTPSessionManager manager] GET:XZYS_SDZQ_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        NSArray *dataArray = responseObject[@"data"];
        if (dataArray.count > 0) {
            for (NSDictionary *dict in dataArray) {
                SDZCModel *model = [[SDZCModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [weakSelf.SDQArray addObject:model];
            }
        }
        // collection按钮和展示
        [weakSelf showCollection];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
#pragma mark - 轮播图数据
    
    [[AFHTTPSessionManager manager] GET:XZYS_LBT_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        NSArray *dataArray = responseObject[@"data"];
        if (dataArray.count > 0) {
            for (NSDictionary *dict in dataArray) {
                LBTModel *model = [[LBTModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [weakSelf.LBTArray addObject:model];
            }
        }
        // 轮播图
        [weakSelf LBTView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

#pragma mark - 四大按钮

// 按钮
- (void)fourButton {
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH / 2.1 + 10, SCREEN_WIDTH, 65)];
    [self.headerBackView addSubview:self.backView];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //给定button在view上的位置
    button1.frame = CGRectMake(SCREEN_WIDTH / 16, 0, 65, 65);
    //button背景色
    button1.backgroundColor = [UIColor clearColor];
    //设置button填充图片
    
    [button1 setImage:[UIImage imageNamed:@"index_20.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(CGRectGetMaxX(button1.frame) + (SCREEN_WIDTH - SCREEN_WIDTH / 8 - 260) / 3, 0, 65, 65);
    button2.backgroundColor = [UIColor clearColor];
    [button2 setImage:[UIImage imageNamed:@"index_17.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(CGRectGetMaxX(button2.frame) + (SCREEN_WIDTH - SCREEN_WIDTH / 8 - 260) / 3, 0, 65, 65);
    button3.backgroundColor = [UIColor clearColor];
    [button3 setImage:[UIImage imageNamed:@"index_23.png"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 16 - 65, 0, 65, 65);
    button4.backgroundColor = [UIColor clearColor];
    [button4 setImage:[UIImage imageNamed:@"index_25.png"] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(button4Click) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:button1];
    [self.backView addSubview:button2];
    [self.backView addSubview:button3];
    [self.backView addSubview:button4];
    
}

// 订单按钮点击事件
- (void)button1Click {
    OrderListViewController *order = [[OrderListViewController alloc] init];
    order.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:order animated:YES];
}
// 分类按钮点击事件
- (void)button2Click {
    ShowAllViewController *classVC = [[ShowAllViewController alloc] init];
    classVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classVC animated:YES];
}
// 调货区按钮点击事件
- (void)button3Click {
    TiaoHuoViewController *order = [[TiaoHuoViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:order animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
// 个人中心按钮点击事件
- (void)button4Click {
    UserViewController *userVC = [[UserViewController alloc] init];
    //根据下标选择
    [self.tabBarController setSelectedIndex:3];
    //根据视图控制器来选择    
    [self.tabBarController.navigationController pushViewController:userVC animated:YES];
}

#pragma mark -  三个分区按钮
- (void)showCollection {
    UIView *collectionButtonView = [[UIView alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(self.backView.frame) + 10, SCREEN_WIDTH - 4, SCREEN_WIDTH / 2.1)];
    collectionButtonView.layer.cornerRadius = 4;
    collectionButtonView.backgroundColor = XZYSRGBColor(45, 190, 250);
    [self.headerBackView addSubview:collectionButtonView];
    
    UILabel *zhuLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(collectionButtonView.frame) + 29, SCREEN_WIDTH - 40, 20)];
    zhuLab.text = @"查看更多商品";
    zhuLab.textAlignment = NSTextAlignmentCenter;
    zhuLab.font = [UIFont systemFontOfSize:12];
    zhuLab.textColor = XZYSBlueColor;
    [self.headerBackView addSubview:zhuLab];
    
    
    // 把n张图片放到imageView上
    NSMutableArray *tempAry = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        SDZCModel *model = [[SDZCModel alloc] init];
        model = self.SDQArray[i];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.img];
//        [imageView sd_setImageWithURL:urlStr];
        [tempAry addObject:urlStr];
    }
    
    // 男鞋
    UIImageView *manImageBT = [[UIImageView alloc] init];
    manImageBT.frame = CGRectMake(2, 2, collectionButtonView.frame.size.width / 3 - 3, collectionButtonView.frame.size.width / 2.1 - 2);
    NSString *aimage = tempAry[0];
    manImageBT.layer.cornerRadius = 3;
    manImageBT.layer.masksToBounds = YES;
    [manImageBT sd_setImageWithURL:[NSURL URLWithString:aimage]];
    [manImageBT setUserInteractionEnabled:YES];
    [manImageBT addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manImageBTClick:)]];
    [collectionButtonView addSubview:manImageBT];
    
    // 女鞋
    UIImageView *womanImageBT = [[UIImageView alloc] init];
    womanImageBT.frame = CGRectMake(CGRectGetMaxX(manImageBT.frame) + 2, 2, collectionButtonView.frame.size.width / 3 - 2, collectionButtonView.frame.size.width / 2.1 - 2);
    NSString *bimage = tempAry[1];
    womanImageBT.layer.cornerRadius = 3;
    womanImageBT.layer.masksToBounds = YES;
    [womanImageBT sd_setImageWithURL:[NSURL URLWithString:bimage]];
    [womanImageBT setUserInteractionEnabled:YES];
    [womanImageBT addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(womanImageBTClick:)]];
    
    [collectionButtonView addSubview:womanImageBT];
    
    // 童鞋
    UIImageView *childImageBT = [[UIImageView alloc] init];
    childImageBT.frame = CGRectMake(CGRectGetMaxX(womanImageBT.frame) + 2, 2, collectionButtonView.frame.size.width / 3 - 3, collectionButtonView.frame.size.width / 2.1 - 2);
    childImageBT.layer.cornerRadius = 3;
    childImageBT.layer.masksToBounds = YES;
    NSString *cimage = tempAry[2];
    [childImageBT sd_setImageWithURL:[NSURL URLWithString:cimage]];
    [childImageBT setUserInteractionEnabled:YES];
    [childImageBT addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childImageBTClick:)]];
    
    [collectionButtonView addSubview:childImageBT];
}

// 女鞋
- (void)manImageBTClick:(UITapGestureRecognizer *)sender {
    
    UINavigationController *secVC = self.tabBarController.viewControllers[1];
    UIViewController *secrootvc = secVC.viewControllers[0];
    if ([secrootvc isKindOfClass:NSClassFromString(@"ClassifyViewController")]) {
        ClassifyViewController *classVC = (ClassifyViewController *)secrootvc;
        classVC.abc = 0;
        classVC.URLStr = [NSMutableString stringWithFormat:@"%@1", XZYS_FLZDH_URL];
        [classVC.view setNeedsDisplay];
        [self.tabBarController.navigationController
         pushViewController:classVC animated:YES];
    }
    [self.tabBarController setSelectedIndex:1];
}
- (void)womanImageBTClick:(UITapGestureRecognizer *)sender {
    
    UINavigationController *secVC = self.tabBarController.viewControllers[1];
    UIViewController *secrootvc = secVC.viewControllers[0];
    if ([secrootvc isKindOfClass:NSClassFromString(@"ClassifyViewController")]) {
        ClassifyViewController *classVC = (ClassifyViewController *)secrootvc;
        classVC.abc = 1;
        classVC.URLStr = [NSMutableString stringWithFormat:@"%@2", XZYS_FLZDH_URL];
        [classVC.view setNeedsDisplay];
        [self.tabBarController.navigationController
         pushViewController:classVC animated:YES];
    }
    [self.tabBarController setSelectedIndex:1];
}

// 童鞋
- (void)childImageBTClick:(UITapGestureRecognizer *)sender {
    [[AFHTTPSessionManager manager] GET:[NSMutableString stringWithFormat:@"%@3", XZYS_FLZDH_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *NVArray = responseObject[@"data"];
        //获取数据源
        for (NSDictionary *dic1 in NVArray) {
            dataArray = [dic1 objectForKey:@"cate_list"];
        }
        if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
            UINavigationController *secVC = self.tabBarController.viewControllers[1];
            UIViewController *secrootvc = secVC.viewControllers[0];
            ClassifyViewController *classVC = (ClassifyViewController *)secrootvc;
            classVC.abc = 2;
            classVC.URLStr = [NSMutableString stringWithFormat:@"%@3", XZYS_FLZDH_URL];
            
            if ([secrootvc isKindOfClass:NSClassFromString(@"ClassifyViewController")]) {
                
                [classVC.view setNeedsDisplay];
                [self.tabBarController.navigationController
                 pushViewController:classVC animated:YES];
            }
            [self.tabBarController setSelectedIndex:1];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"该类商品尚未上架，敬请期待";
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.dataID isEqualToString:@"21"]) {
        [self requesdCollectionData];
    }
    self.dataID = @"21";
    [self setReadView];
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
