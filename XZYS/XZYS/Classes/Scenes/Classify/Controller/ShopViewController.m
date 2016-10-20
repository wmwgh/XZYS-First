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
#import "XiTongViewController.h"
#import "SearchViewController.h"
#import "SDFQModel.h"
#import "ShopHeadReusableView.h"
#import "UIView+LoadFromNib.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "ShaiXuanViewCell.h"
#import "ShaiXuanHeaderView.h"
#import "PickerViewHeaderView.h"
#import "ZQViewCell.h"
#import "CZViewCell.h"
#import "NLViewCell.h"
#import "XGViewCell.h"
#import "JJViewCell.h"
#import "YSViewCell.h"
#import "XIangQingViewController.h"

static NSString *const identifier_cell = @"identifier_cell";
static NSString *const firatID = @"firstHeader";//图和字和线
@interface ShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *MButton;
}
/** 页码*/
@property (nonatomic, assign) int page;
@property (nonatomic , strong) NSMutableDictionary *param;
@property (nonatomic , strong) UIButton *priceButton;
@property (nonatomic , strong) UIButton *timeButton;
@property (nonatomic , strong) UIButton *numButton;
@property (nonatomic , strong) UIButton *priceButton1;
@property (nonatomic , strong) UIImageView *image1;
@property (nonatomic , strong) UIView *underView;

@property (nonatomic , copy) NSString *price1;
@property (nonatomic , copy) NSString *price2;
@property (nonatomic , strong) UITextField *textFileda;
@property (nonatomic , strong) UITextField *textFiledb;
@property (nonatomic , strong) UIButton * collectButton;
/// 搜索
@property (strong, nonatomic) UITextField *searchText;
@property (nonatomic , strong) ShopView *rootView;
@property (nonatomic , strong) ShopHeadReusableView *headView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *collectionArray;

@end

@implementation ShopViewController

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"店铺";
    self.page = 2;
    // 请求数据
//    [self requestData];
    [self setCollection];
    [self setNavigation];
    // 添加顶部刷新
    [self addRefresh];
    [self setSXView];
}

- (void)addRefresh {
    
    self.rootView.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.rootView.collectionView.mj_header.automaticallyChangeAlpha = YES;
    [self.rootView.collectionView.mj_header beginRefreshing];
    self.rootView.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreDataShop)];
}
- (void)setSXView {
    self.underView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.underView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.7];
    UIButton *backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBT addTarget:self action:@selector(backBTAction) forControlEvents:UIControlEventTouchUpInside];
    backBT.frame = self.view.bounds;
    backBT.backgroundColor = [UIColor clearColor];
    [self.underView addSubview:backBT];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.underView addSubview:backView];
    [self.view addSubview:self.underView];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 230, 20)];
    titleLab.text = @"请选择价格区间";
    titleLab.textColor = XZYSPinkColor;
    titleLab.font = [UIFont systemFontOfSize:15];
    [backView addSubview:titleLab];
    
    self.textFileda = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, 80, 25)];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textFileda.frame) + 10, 51, 15, 2)];
    aView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:aView];
    self.textFiledb = [[UITextField alloc] initWithFrame:CGRectMake(125, 40, 80, 25)];
    
    self.textFileda.textAlignment = NSTextAlignmentCenter;
    self.textFiledb.layer.cornerRadius = 5;
    self.textFileda.text = @"0";
    self.textFiledb.text = @"500";
    self.textFiledb.layer.borderWidth = 0.5;
    self.textFiledb.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textFileda.layer.borderWidth = 0.5;
    self.textFileda.layer.cornerRadius = 5;
    self.textFileda.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textFiledb.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.textFileda];
    [backView addSubview:self.textFiledb];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(SCREEN_WIDTH - 90, 40, 80, 25);
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"loginButton.png"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:sureBtn];
    self.underView.hidden = YES;
}
- (void)backBTAction {
    self.underView.hidden = YES;
}
- (void)sureBtnAction {
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [self.collectionArray removeAllObjects];
    self.price1 = self.textFileda.text;
    self.price2 = self.textFiledb.text;
    if (self.price1 != nil) {
        self.param[@"start_price"] = self.price1;
    }
    if (self.price2 != nil) {
        self.param[@"end_price"] = self.price2;
    }
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Goods/goodsList" parameters:self.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([str isEqualToString:@"-101"]) {
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in dataArray) {
                SDFQModel *model = [[SDFQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.collectionArray addObject:model];
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
        
    }];
    self.underView.hidden = YES;
}



- (void)setCollection {
    self.rootView = [[ShopView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT- 44)];
    [self.view addSubview:self.rootView];
    // 设置代理
    self.rootView.collectionView.dataSource = self;
    self.rootView.collectionView.delegate = self;
    
    // 第一步：注册cell
    [self.rootView.collectionView registerClass:[RootCell class] forCellWithReuseIdentifier:identifier_cell];
    
    self.headView = [[ShopHeadReusableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 247)];
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectButton.frame = CGRectMake(SCREEN_WIDTH - 45, 179, 36, 36);
    [self.collectButton setImage:[UIImage imageNamed:@"dp_scc.png"] forState:UIControlStateNormal];
    [self.collectButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView bringSubviewToFront:self.collectButton];
    self.collectButton.userInteractionEnabled = YES;
    [self.headView addSubview:self.collectButton];
    
    self.headView.userInteractionEnabled = YES;
    [self.rootView.collectionView addSubview:self.headView];
    /// 添加选择按钮
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 215, SCREEN_WIDTH, 42)];
    pickBackView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:pickBackView];
    self.numButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numButton.frame = CGRectMake(0, 0, SCREEN_WIDTH / 4, 42);
    [self.numButton setTitle:@"销 量" forState:UIControlStateNormal];
    self.numButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.numButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:self.numButton];
    
    self.priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priceButton.frame = CGRectMake(SCREEN_WIDTH / 4 - 10, 0, SCREEN_WIDTH / 4, 42);
    [self.priceButton setTitle:@"价 格" forState:UIControlStateNormal];
    self.priceButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.priceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.priceButton addTarget:self action:@selector(priceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:self.priceButton];
    self.image1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 31, 13, 8, 16)];
    self.image1.image = [UIImage imageNamed:@"lb_jtc"];
    [pickBackView addSubview:self.image1];
    self.priceButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priceButton1.frame = CGRectMake(SCREEN_WIDTH / 4 - 10, 0, SCREEN_WIDTH / 4, 42);
    [self.priceButton1 setTitle:@"价 格" forState:UIControlStateNormal];
    self.priceButton1.titleLabel.font = [UIFont systemFontOfSize: 16];
    self.priceButton1.hidden = YES;
    [self.priceButton1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.priceButton1 addTarget:self action:@selector(priceButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:self.priceButton1];
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timeButton.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 4, 42);
    [self.timeButton setTitle:@"时 间" forState:UIControlStateNormal];
    //    [timeButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:self.timeButton];
    
    UIButton *sxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sxButton.frame = CGRectMake(SCREEN_WIDTH * 3 / 4, 0, SCREEN_WIDTH / 4, 42);
    [sxButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    sxButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [sxButton setTitle:@"区 间" forState:UIControlStateNormal];
    [sxButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sxButton addTarget:self action:@selector(sxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:sxButton];

}

- (void)collect:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appd.userIdTag;
    params[@"shop_id"] = str;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/collectShop" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSDictionary *dic = responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-900"]){
            hud.labelText = dic[@"msg"];
            [self.collectButton setImage:[UIImage imageNamed:@"dp_sca"] forState:UIControlStateNormal];
        } else {
            hud.labelText = dic[@"msg"];
            [self.collectButton setImage:[UIImage imageNamed:@"dp_scc"] forState:UIControlStateNormal];
        }
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)numButtonClick:(UIButton *)sender {
    self.param[@"order"] = @"sales";
    self.priceButton1.hidden = YES;
    self.priceButton.hidden  = NO;
    self.image1.image = [UIImage imageNamed:@"lb_jtc"];
    [self.priceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.numButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self requestAllData];
}
- (void)priceButtonClick:(UIButton *)sender {
    self.param[@"order"] = @"up_price";
    self.priceButton1.hidden = NO;
    self.priceButton.hidden = YES;
    [self.priceButton1 setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    self.image1.image = [UIImage imageNamed:@"lb_jtb"];
    [self.timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self requestAllData];
}
- (void)priceButton1Click:(UIButton *)sender {
    self.param[@"order"] = @"down_price";
    self.priceButton1.hidden = YES;
    self.priceButton.hidden = NO;
    self.image1.image = [UIImage imageNamed:@"lb_jta"];
    [self.priceButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self.timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self requestAllData];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self yanzheng];
}
- (void)yanzheng {
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appd.userIdTag;
    params[@"shop_id"] = self.shopID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/checkCollectShop/shop_id/16" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSDictionary *dic = responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        if([result isEqualToString:@"-902"]){
            [self.collectButton setImage:[UIImage imageNamed:@"dp_scc"] forState:UIControlStateNormal];
        } else {
            [self.collectButton setImage:[UIImage imageNamed:@"dp_sca"] forState:UIControlStateNormal];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)timeButtonClick:(UIButton *)sender {
    self.param[@"order"] = @"create_time";
    self.priceButton1.hidden = YES;
    self.priceButton.hidden  = NO;
    self.image1.image = [UIImage imageNamed:@"lb_jtc"];
    [self.priceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.timeButton setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [self requestAllData];
}
- (void)sxButtonClick:(UIButton *)sender {
    self.priceButton1.hidden = YES;
    self.priceButton.hidden  = NO;
    self.image1.image = [UIImage imageNamed:@"lb_jtc"];
    [self.priceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    self.underView.hidden = NO;
}
#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    _collectionArray = [NSMutableArray array];
    [_collectionArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [weakSelf.param setValue:weakSelf.shopID forKey:@"shop_id"];
    [weakSelf.param setValue:nil forKey:@"page"];
    [[AFHTTPSessionManager manager] GET:XZYS_ALL_URL parameters:weakSelf.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
            for (NSDictionary *dic in dataArray) {
                SDFQModel *model = [[SDFQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.collectionArray addObject:model];
            }
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

- (void)requestData {
    __weak typeof(self) weakSelf = self;
    [weakSelf.dataArray removeAllObjects];
    weakSelf.dataArray = [NSMutableArray array];
    [weakSelf.collectionArray removeAllObjects];
    weakSelf.collectionArray = [NSMutableArray array];
    self.param = nil;
    self.price1 = nil;
    self.price2 = nil;
    if (weakSelf.shopID != nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_DP_URL, weakSelf.shopID];
        [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            NSDictionary *dataDic = responseObject[@"data"];
            ShopModel *model = [[ShopModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            [weakSelf.dataArray addObject:model];
            
            self.headView.titleLabel.text = model.shop_name;
            self.headView.baclImageView.image = [UIImage imageNamed:@"dpbjt.jpg"];
            [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.shop_logo]]];
            self.collectButton.tag = [model.ID intValue];
            self.headView.numLabel.text = model.goods_num;
            self.headView.dianPuCollect.text = model.sales_num;
            self.headView.goodsCollect.text = model.collect_num;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            // 显示加载错误信息
            [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
        }];
        
        
        /// collection 数据请求
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"shop_id"] = weakSelf.shopID;
        [[AFHTTPSessionManager manager] GET:XZYS_ALL_URL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            NSArray *dataArr = responseObject[@"data"];
            if (dataArr != nil && ![dataArr isKindOfClass:[NSNull class]] && dataArr.count != 0) {
                for (NSDictionary *dic in dataArr) {
                    SDFQModel *model = [[SDFQModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [weakSelf.collectionArray addObject:model];
                }
            }
            [self.rootView.collectionView reloadData];
            //结束刷新
            [self.rootView.collectionView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            // 显示加载错误信息
            [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
        }];
    } else {
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"无法找到该店铺"];
    }
}

- (void)requestMoreDataShop {
    __weak typeof(self) weakSelf = self;
    //请求参数
    weakSelf.param[@"page"] = [NSString stringWithFormat:@"%d", self.page];
    /// collection 数据请求
    [[AFHTTPSessionManager manager] GET:XZYS_ALL_URL parameters:weakSelf.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        NSArray *dataArr = responseObject[@"data"];
        if (dataArr != nil && ![dataArr isKindOfClass:[NSNull class]] && dataArr.count != 0) {
            self.page++;
            for (NSDictionary *dic in dataArr) {
                SDFQModel *model = [[SDFQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.collectionArray addObject:model];
            }
        } else {
            //结束刷新
            [self.rootView.collectionView.mj_footer endRefreshing];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"商品已全部更新";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
        }
        [self.rootView.collectionView reloadData];
        //结束刷新
        [self.rootView.collectionView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
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

// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XIangQingViewController *XXVC = [[XIangQingViewController alloc] init];
    SDFQModel *model = [[SDFQModel alloc] init];
    model = self.collectionArray[indexPath.row];
    XXVC.model = model;
    XXVC.passID = model.goods_id;
    XXVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:XXVC animated:YES];
    
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
    
    self.searchText = [[UITextField alloc] initWithFrame:CGRectMake(45, 8, SCREEN_WIDTH - 90, 30)];
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
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.searchID = self.searchText.text;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -  消息
- (void)messageButtonClick:(UIButton *)sender {
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
