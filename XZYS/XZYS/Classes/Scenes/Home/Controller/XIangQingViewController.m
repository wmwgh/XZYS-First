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
#import "ShoppingCarViewController.h"
#import <UIImageView+WebCache.h>
#import "FzhScrollViewAndPageView.h"
#import "ShopViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <MBProgressHUD.h>

#define btWidth (SCREEN_WIDTH - SCREEN_WIDTH / 3) / 4
@interface XIangQingViewController ()<FzhScrollViewDelegate,LFLUISegmentedControlDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSMutableDictionary *dict;
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
@property (nonatomic , strong) UITableView *mainTable;
@property (nonatomic , strong) UIScrollView *backScr;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) NSArray *LFLarray;
@property (nonatomic , strong) UIButton *dianpuBT;
@property (nonatomic , strong) UIButton *shoucangBT;
@property (nonatomic, strong) UIScrollView *mainScrollView; /**< 正文mainSV */
@property (nonatomic ,strong) LFLUISegmentedControl * LFLuisement; /**< LFLuisement */
@property (nonatomic, strong) SPXQModel *GuiGeModel;
@property (nonatomic ,strong) GoodsTableViewCell *goodsScroll;
@property (nonatomic, strong) FzhScrollViewAndPageView *fzhView;
@end

@implementation XIangQingViewController

- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (NSMutableArray *)SpxqPicArray {
    if (!_SpxqPicArray) {
        _SpxqPicArray = [NSMutableArray array];
    }
    return _SpxqPicArray;
}

- (NSMutableArray *)SPXQArray {
    if (!_SPXQArray) {
        _SPXQArray = [NSMutableArray array];
    }
    return _SPXQArray;
}

- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    _cellHeight = 5;
    self.LFLarray = [NSArray array];
    // 请求数据
    [self requestData];
    // 详情按钮
    [self initXQView];
    // 导航
    [self initLayoutSegmt];
    // 主scrollView
    [self createMainScrollView];
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
//SCREEN_WIDTH + 64 + 7 + 40 + 80;
- (void)createTableView {
    self.backScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backScr.bounces = NO;
    self.backScr.pagingEnabled = NO;
    self.backScr.showsVerticalScrollIndicator = NO;
    self.backScr.showsHorizontalScrollIndicator = NO;
    self.backScr.contentSize = CGSizeMake(SCREEN_WIDTH , SCREEN_WIDTH + _cellHeight + 250);
    //设置代理
    self.backScr.delegate = self;
    [self LBTView];
    [self addThreeView];
    [self.mainScrollView addSubview:self.backScr];
    
}

- (void)addThreeView {
    SPXQModel *model = self.SPXQArray[0];
    DetailView *detailView = [DetailView loadFromNib];
    detailView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    detailView.xiangqingLabel.text = model.goods_datails;
    [self.mainScrollView addSubview:detailView];
    
    GuiGeView *guigeView = [GuiGeView loadFromNib];
    guigeView.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    NSString *sizeString = [NSString string];
    for (NSString *sizeStr in self.SpxqSizeArray) {
        sizeString = [sizeString stringByAppendingString:[NSString stringWithFormat:@"%@ ", sizeStr]];
    }
    NSString *colorString = [NSString string];
    for (NSString *colorStr in self.SpxqColorArray) {
        colorString = [colorString stringByAppendingString:[NSString stringWithFormat:@"%@ ", colorStr]];
    }
    guigeView.yanse.text = colorString;
    guigeView.chicun.text = sizeString;
    guigeView.xiemiancailiao.text = model.material;
    guigeView.xiegenleixing.text = model.heel;
    guigeView.gongneng.text = model.function;
    guigeView.fengge.text = model.style;
    guigeView.xietoukuanshi.text = model.topstyle;
    guigeView.xiedicaizhi.text = model.solematerial;
    guigeView.xielicaizhi.text = model.linmater;
    guigeView.shiYong.text = model.audience;
    [self.mainScrollView addSubview:guigeView];
}

#pragma mark --- 轮播图
- (void)LBTView {
    //创建view（view中包含UIScrollView、UIPageControl，设置frame）
    _fzhView = [[FzhScrollViewAndPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *str in self.SpxqPicArray) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, str];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        [tempArray addObject:imageView];
    }
    //把imageView数组存到fzhView里
    [_fzhView setImageViewAry:tempArray];
    //开启自动翻页
    [_fzhView shouldAutoShow:YES];
    //遵守协议
    _fzhView.delegate = self;
    //把图片展示的view加到当前页面
    [self.backScr addSubview:_fzhView];
#pragma mark - 商品信息
    SPXQModel *model = self.SPXQArray[0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_fzhView.frame) + 3, SCREEN_WIDTH - 10, 35)];
    titleLabel.text = model.goods_name;
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backScr addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame) + 3, 80, 20)];
    priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    priceLabel.textColor = XZYSBlueColor;
    priceLabel.font = [UIFont systemFontOfSize:16];
    [self.backScr addSubview:priceLabel];
    
    UILabel *zheluLab = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(titleLabel.frame) + 3, SCREEN_WIDTH - 95, 20)];
    zheluLab.textColor = XZYSPinkColor;
    zheluLab.text = [NSString stringWithFormat:@"注:%@", model.goods_desc];
    zheluLab.font = [UIFont systemFontOfSize:11];
    zheluLab.textAlignment = NSTextAlignmentRight;
    [self.backScr addSubview:zheluLab];

    UILabel *beforePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(priceLabel.frame) + 3, 80, 18)];
    beforePriceLabel.text = [NSString stringWithFormat:@"价格￥%@", model.ori_price];
    beforePriceLabel.textColor = XZYSRGBColor(232, 184, 66);
    beforePriceLabel.font = [UIFont systemFontOfSize:12];
    [self.backScr addSubview:beforePriceLabel];
    
    UIView *elineView = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(beforePriceLabel.frame) + 9, 46, 1)];
    elineView.backgroundColor = XZYSRGBColor(232, 184, 66);
    [self.backScr addSubview:elineView];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(priceLabel.frame) + 3, SCREEN_WIDTH - 95, 18)];
    
    numLabel.textColor = XZYSPinkColor;
    numLabel.text = [NSString stringWithFormat:@"销量:%@件", model.sales_num];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.font = [UIFont systemFontOfSize:11];
    [self.backScr addSubview:numLabel];
    
    UIView *alineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(beforePriceLabel.frame) + 3, SCREEN_WIDTH - 10, 1)];
    alineView.backgroundColor = XZYSLightDarkColor;
    [self.backScr addSubview:alineView];
    
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(alineView.frame), SCREEN_WIDTH, _cellHeight)];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.backScr addSubview:self.mainTable];
    
    UIView *blineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.mainTable.frame), SCREEN_WIDTH - 10, 1)];
    blineView.backgroundColor = XZYSLightDarkColor;
    [self.backScr addSubview:blineView];
    UILabel *picklabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(blineView.frame), SCREEN_WIDTH - 70, 40)];
    picklabel.text = @"选择   颜色   尺码";
    picklabel.font = [UIFont systemFontOfSize:15];
    [self.backScr addSubview:picklabel];
    
    UIImageView *imagea = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 33, CGRectGetMaxY(blineView.frame) + 11, 15, 20)];
    imagea.image = [UIImage imageNamed:@"bz_22"];
    [self.backScr addSubview:imagea];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(blineView.frame), SCREEN_WIDTH, 40)];
    imageView.backgroundColor = [UIColor clearColor];
    [self.backScr bringSubviewToFront:imageView];
    [self.backScr addSubview:imageView];
    
    UIView *clineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(imageView.frame) + 1, SCREEN_WIDTH - 10, 1)];
    clineView.backgroundColor = XZYSLightDarkColor;
    [self.backScr addSubview:clineView];
    
    UIView *dlineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(clineView.frame) + 5, SCREEN_WIDTH - 10, 1)];
    dlineView.backgroundColor = XZYSLightDarkColor;
    [self.backScr addSubview:dlineView];
    // 隐藏指示器
    [SVProgressHUD dismiss];
}

#pragma mark --- 协议里面方法，点击某一页
-(void)didClickPage:(FzhScrollViewAndPageView *)view atIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld页",index);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.SPXQArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.SPXQArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainTable deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH + 256 + _cellHeight;
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;
    [weakSelf.SpxqPicArray removeAllObjects];
    weakSelf.SpxqSizeArray = [NSMutableArray array];
    [weakSelf.SpxqSizeArray removeAllObjects];
    weakSelf.SpxqColorArray = [NSMutableArray array];
    [weakSelf.SpxqColorArray removeAllObjects];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_SPXQ_URL, weakSelf.passID];
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        _dict = responseObject[@"data"];
        NSDictionary *sizeDic = _dict[@"size"];
        NSDictionary *colorDic = _dict[@"color_remark"];
        weakSelf.SpxqPicArray = _dict[@"goods_img_list"];
        
        [sizeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *str = obj;
            [weakSelf.SpxqSizeArray addObject:str];
        }];
        [colorDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *str = obj;
            [weakSelf.SpxqColorArray addObject:str];
        }];
        weakSelf.GuiGeModel = [[SPXQModel alloc] init];
        [weakSelf.GuiGeModel setValuesForKeysWithDictionary:_dict];
        [weakSelf.SPXQArray addObject:weakSelf.GuiGeModel];
        [self createTableView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
        NSLog(@"%@", error);
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
    [carBT addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
    carBT.backgroundColor = [UIColor blueColor];
    [bBackView addSubview:carBT];
    
    UIButton *kefuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    kefuBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [kefuBT setImage:[UIImage imageNamed:@"kf"] forState:UIControlStateNormal];
    kefuBT.frame = CGRectMake(0, 8, btWidth, 40);
    [kefuBT addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    [bBackView addSubview:kefuBT];
    
    self.shoucangBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shoucangBT.titleLabel.font = [UIFont systemFontOfSize:14];
    self.shoucangBT.frame = CGRectMake(btWidth, 8, btWidth, 40);
    [self.shoucangBT addTarget:self action:@selector(shoucangAction:) forControlEvents:UIControlEventTouchUpInside];
    [bBackView addSubview:self.shoucangBT];
    
    self.dianpuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dianpuBT.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dianpuBT.frame = CGRectMake(btWidth * 2, 8, btWidth, 40);
    [self.dianpuBT setImage:[UIImage imageNamed:@"dp"] forState:UIControlStateNormal];
    [self.dianpuBT addTarget:self action:@selector(dianpuClick:) forControlEvents:UIControlEventTouchUpInside];
    [bBackView addSubview:self.dianpuBT];
    
    UIButton *gouwucheBT = [UIButton buttonWithType:UIButtonTypeCustom];
    gouwucheBT.titleLabel.font = [UIFont systemFontOfSize:14];
    gouwucheBT.frame = CGRectMake(btWidth * 3, 8, btWidth, 40);
    [gouwucheBT setImage:[UIImage imageNamed:@"gwc"] forState:UIControlStateNormal];
    [gouwucheBT addTarget:self action:@selector(gouwuche:) forControlEvents:UIControlEventTouchUpInside];
    [bBackView addSubview:gouwucheBT];
    [self.view addSubview:bBackView];
    [self.view addSubview:self.backView];
}

- (void)yanzheng {
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appd.userIdTag;
    params[@"goods_id"] = self.passID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/checkCollectGoods" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSDictionary *dic = responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        if([result isEqualToString:@"-902"]){
        [self.shoucangBT setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
        } else {
        [self.shoucangBT setImage:[UIImage imageNamed:@"sc_dp"] forState:UIControlStateNormal];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//  加入购物车
- (void)addGoods {
}
//  收藏
- (void)shoucangAction:(UIButton *)esnder {
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appd.userIdTag;
    params[@"goods_id"] = self.passID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/collectGoods" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSDictionary *dic = responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-900"]){
            hud.labelText = dic[@"msg"];
            [self.shoucangBT setImage:[UIImage imageNamed:@"sc_dp"] forState:UIControlStateNormal];
        } else {
            hud.labelText = dic[@"msg"];
            [self.shoucangBT setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
        }
        NSLog(@"request:%@", dic[@"msg"]);
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
//  店铺
- (void)dianpuClick:(UIButton *)sender {
    ShopViewController *dianpuVC = [[ShopViewController alloc] init];
    dianpuVC.shopID = _dict[@"shop_id"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dianpuVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}
//  购物车
- (void)gouwuche:(UIButton *)dender {
    ShoppingCarViewController *carVC = [[ShoppingCarViewController alloc] init];
    self.tabBarController.selectedIndex = 2;
    self.hidesBottomBarWhenPushed = NO;
    [self.tabBarController.navigationController pushViewController:carVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
// 客服
- (void)kefuClick {
}

- (void)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self yanzheng];
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
