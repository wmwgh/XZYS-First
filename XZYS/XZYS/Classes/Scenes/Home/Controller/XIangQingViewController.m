//
//  XIangQingViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/16.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "XIangQingViewController.h"
#import "Goods.h"
#import "XZYS_Other.h"
#import "UIView+LoadFromNib.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "SPXQModel.h"
#import <SVProgressHUD.h>
#import "LFLUISegmentedControl.h"
#import "GoodsTableViewCell.h"
#import "DetailView.h"
#import "GuiGeView.h"


#define btWidth (SCREEN_WIDTH - SCREEN_WIDTH / 3) / 4
@interface XIangQingViewController ()<LFLUISegmentedControlDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIScrollView *backView;
/// 商品详情数组
@property (nonatomic, strong) NSMutableArray *SPXQArray;
/// 商品详情图片数组
@property (nonatomic, strong) NSMutableArray *SpxqPicArray;
/// 商品详情颜色数组
@property (nonatomic, strong) NSMutableArray *SpxqColorArray;
/// 商品详情尺寸数组
@property (nonatomic, strong) NSMutableArray *SpxqSizeArray;
/// 商品详情季节数组
@property (nonatomic, strong) NSMutableArray *SpxqSeasonArray;

@property (nonatomic , strong) NSArray *array;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) NSArray *LFLarray;
@property (nonatomic, strong) UIScrollView *mainScrollView; /**< 正文mainSV */
@property (nonatomic ,strong) LFLUISegmentedControl * LFLuisement; /**< LFLuisement */
@property (nonatomic, strong) SPXQModel *GuiGeModel;

@end

@implementation XIangQingViewController

- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (NSMutableArray *)SPXQArray {
    if (!_SPXQArray) {
        _SPXQArray = [NSMutableArray array];
    }
    return _SPXQArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = 500;
    self.LFLarray = [NSArray array];
    // 请求数据
    [self requestData];
    NSLog(@"%@", self.model.goods_id);
    // 详情按钮
    [self initXQView];
    // 导航
    [self initLayoutSegmt];
    // 主scrollView
    [self createMainScrollView];

    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
}

- (void)initLayoutSegmt {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //    1.初次创建：
    LFLUISegmentedControl* LFLuisement=[[LFLUISegmentedControl alloc]initWithFrame:CGRectMake(90, 20, SCREEN_WIDTH - 180, 44)];
    LFLuisement.delegate = self;
    //   2.设置显示切换标题数组
    self.LFLarray = [NSArray arrayWithObjects:@"商 品",@"详 情",@"规 格",nil];
    
    [LFLuisement AddSegumentArray:self.LFLarray];
    //   default Select the Button
    [LFLuisement selectTheSegument:0];
    self.LFLuisement = LFLuisement;
    [self.view addSubview:LFLuisement];
    
    UIButton *backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(17, 32, 13, 20);
    [backBT setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBT];
    
}

- (void)createTableView {
    UITableView *mainTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTable registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self addThreeView];
    [self.mainScrollView addSubview:mainTable];
}
- (void)addThreeView {
    DetailView *detailView = [DetailView loadFromNib];
    detailView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    [self.mainScrollView addSubview:detailView];
    
    GuiGeView *guigeView = [GuiGeView loadFromNib];
    guigeView.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
//    [guigeView setModel:model];
    [self.view reloadInputViews];
    [self.mainScrollView addSubview:guigeView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%ld", self.SPXQArray.count);
    return self.SPXQArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.SPXQArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.changeHeight.constant = _cellHeight;
    SPXQModel *model = self.SPXQArray[indexPath.row];
    NSLog(@"==========%@", model.goods_img);
    [cell setModel:model];
    
 return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH + 256 + _cellHeight;
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:XZYS_SPXQ_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        NSDictionary *THQDic = responseObject[@"data"];
        //        NSArray *THQAr = THQDic[@"goods_list"];
        weakSelf.GuiGeModel = [[SPXQModel alloc] init];
        [weakSelf.GuiGeModel setValuesForKeysWithDictionary:THQDic];
        NSLog(@"%@", weakSelf.GuiGeModel.goods_name);
        [weakSelf.SPXQArray addObject:weakSelf.GuiGeModel];
        NSLog(@"asd%@", weakSelf.SPXQArray);
        [self createTableView];

        // 隐藏指示器
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
}

//创建正文ScrollView内容
- (void)createMainScrollView {
    CGFloat begainScrollViewY = 49 + 64;
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,(SCREEN_HEIGHT - begainScrollViewY))];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.bounces = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, (SCREEN_HEIGHT - begainScrollViewY));
    //设置代理
    self.mainScrollView.delegate = self;
}

#pragma mark --- UIScrollView代理方法

static NSInteger pageNumber = 0;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageNumber = (int)(scrollView.contentOffset.x / SCREEN_WIDTH + 0.5);
//    滑动SV里视图,切换标题
    [self.LFLuisement selectTheSegument:pageNumber];
}

#pragma mark ---LFLUISegmentedControlDelegate
/**
 *  点击标题按钮
 *
 *  @param selection 对应下标 begain 0
 */
-(void)uisegumentSelectionChange:(NSInteger)selection{
    //    加入动画,显得不太过于生硬切换
    [UIView animateWithDuration:.2 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH *selection, 0)];
    }];
}

- (void)initXQView {
    UIView *bBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
    UIButton *carBT = [UIButton buttonWithType:UIButtonTypeCustom];
    carBT.titleLabel.font = [UIFont systemFontOfSize:14];
    carBT.frame = CGRectMake(SCREEN_WIDTH*2 / 3 + 10, 0, SCREEN_WIDTH / 3, 49);
    [carBT setTitle:@"加入购物车" forState:UIControlStateNormal];
    carBT.backgroundColor = [UIColor blueColor];
    [bBackView addSubview:carBT];
    
    UIButton *kefuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    kefuBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [kefuBT setImage:[UIImage imageNamed:@"kf"] forState:UIControlStateNormal];
    kefuBT.frame = CGRectMake(0, 8, btWidth, 40);
    [bBackView addSubview:kefuBT];
    
    UIButton *shoucangBT = [UIButton buttonWithType:UIButtonTypeCustom];
    shoucangBT.titleLabel.font = [UIFont systemFontOfSize:14];
    shoucangBT.frame = CGRectMake(btWidth, 8, btWidth, 40);
    [shoucangBT setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
    [bBackView addSubview:shoucangBT];
    
    UIButton *dianpuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    dianpuBT.titleLabel.font = [UIFont systemFontOfSize:14];
    dianpuBT.frame = CGRectMake(btWidth * 2, 8, btWidth, 40);
    [dianpuBT setImage:[UIImage imageNamed:@"dp"] forState:UIControlStateNormal];
    [bBackView addSubview:dianpuBT];
    
    UIButton *gouwucheBT = [UIButton buttonWithType:UIButtonTypeCustom];
    gouwucheBT.titleLabel.font = [UIFont systemFontOfSize:14];
    gouwucheBT.frame = CGRectMake(btWidth * 3, 8, btWidth, 40);
    [gouwucheBT setImage:[UIImage imageNamed:@"gwc"] forState:UIControlStateNormal];
    [bBackView addSubview:gouwucheBT];
    
    [self.view addSubview:bBackView];
    [self.view addSubview:self.backView];
}


- (void)backButton:(UIButton *)sender {
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
