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
#import "ShopHeadView.h"
#import "UIView+LoadFromNib.h"
#import "AF_MainScreeningViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

static NSString *const identifier_cell = @"identifier_cell";
static NSString *const firatID = @"firstHeader";//图和字和线
@interface ShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *MButton;
}
@property (nonatomic , strong) NSMutableDictionary *param;
@property (nonatomic , strong) UIButton *priceButton;
@property (nonatomic , strong) UIButton *timeButton;
@property (nonatomic , strong) UIButton *numButton;
@property (nonatomic , strong) UIButton *priceButton1;
@property (nonatomic , strong) UIImageView *image1;
/// 搜索
@property (strong, nonatomic) UIImageView *searchIamgeView;
@property (nonatomic , strong) ShopView *rootView;
@property (nonatomic , strong) ShopHeadView *headView;
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
    // 请求数据
    [self requestData];
    [self setCollection];
    [self setNavigation];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callback1:)
                                                 name:@"cbt1"
                                               object:nil];
}

- (void)callback1:(NSNotification *)text {
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appd.userIdTag;
    params[@"shop_id"] = text.userInfo[@"sid"];
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/collectShop" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSDictionary *dic = responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-900"]){
            hud.labelText = dic[@"msg"];
            [self.headView.collectButton setImage:[UIImage imageNamed:@"dp_sca"] forState:UIControlStateNormal];
        } else {
            hud.labelText = dic[@"msg"];
            [self.headView.collectButton setImage:[UIImage imageNamed:@"dp_scc"] forState:UIControlStateNormal];
        }
        NSLog(@"request:%@", dic[@"msg"]);
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)setCollection {
    self.rootView = [[ShopView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT- 44)];
    [self.view addSubview:self.rootView];
    // 设置代理
    self.rootView.collectionView.dataSource = self;
    self.rootView.collectionView.delegate = self;
    
    // 第一步：注册cell
    [self.rootView.collectionView registerClass:[RootCell class] forCellWithReuseIdentifier:identifier_cell];
    self.headView = [[ShopHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    self.headView = [ShopHeadView loadFromNib];
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
    self.image1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 33, 13, 8, 16)];
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
    [sxButton setTitle:@"筛 选" forState:UIControlStateNormal];
    [sxButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sxButton addTarget:self action:@selector(sxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:sxButton];

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
            [self.headView.collectButton setImage:[UIImage imageNamed:@"dp_scc"] forState:UIControlStateNormal];
        } else {
            [self.headView.collectButton setImage:[UIImage imageNamed:@"dp_sca"] forState:UIControlStateNormal];
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
    AF_MainScreeningViewController * testVC = [AF_MainScreeningViewController new];
    //这两句必须有
    self.definesPresentationContext = YES; //self is presenting view controller
    testVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    /** 设置半透明度 */
    testVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    [self presentViewController:testVC animated:NO completion:nil];
}
#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    _collectionArray = [NSMutableArray array];
    [_collectionArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [weakSelf.param setValue:weakSelf.shopID forKey:@"shop_id"];
    NSLog(@"%@", weakSelf.param);
    [[AFHTTPSessionManager manager] GET:XZYS_ALL_URL parameters:weakSelf.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        
        for (NSDictionary *dic in dataArray) {
            SDFQModel *model = [[SDFQModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [weakSelf.collectionArray addObject:model];
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
    
    if (weakSelf.shopID != nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_DP_URL, weakSelf.shopID];
        [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            NSDictionary *dataDic = responseObject[@"data"];
            ShopModel *model = [[ShopModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            [weakSelf.dataArray addObject:model];
            
            self.headView.titleLabel.text = model.shop_name;
            self.headView.baclImageView.image = [UIImage imageNamed:@"daji.jpg"];
            [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.shop_logo]]];
            self.headView.collectButton.tag = [model.ID intValue];
            self.headView.numLabel.text = model.goods_num;
            self.headView.dianPuCollect.text = model.sales_num;
            self.headView.goodsCollect.text = model.collect_num;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            // 显示加载错误信息
            [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
            NSLog(@"%@", error);
        }];
        
        
        /// collection 数据请求
        [weakSelf.param setValue:weakSelf.shopID forKey:@"shop_id"];
        NSLog(@"%@", weakSelf.param);
        [[AFHTTPSessionManager manager] GET:XZYS_ALL_URL parameters:weakSelf.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
