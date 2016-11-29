//
//  ClassifyViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ClassifyViewController.h"
#import "SMVerticalSegmentedControl.h"
#import "FLModel.h"
#import "ShopCollectionViewCell.h"
#import "XZYS_Other.h"
#import "XZYS_URL.h"
#import "XiTongViewController.h"
#import "SearchViewController.h"
#import <SVProgressHUD.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh.h>
#import "ShowAllViewController.h"
#import "HomeViewController.h"
#import "ShowAllViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <MBProgressHUD.h>

@interface ClassifyViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIScrollViewDelegate>
{
    //数据源数组
    NSMutableArray *dataArr;
    //数组字典
    NSMutableDictionary *dataDic;
    NSMutableArray *allkeys;
    NSMutableArray *sectionTitleArray;
    NSMutableArray *rowmodelArray;
    NSMutableArray *FCidArray;
    NSInteger NVNum;
    NSMutableArray *pushAllDetailsArray;
    UIButton *MButton;
}
@property (nonatomic , strong) UIView *redView;
@property (nonatomic , strong) NSMutableArray *spArray;
@property (nonatomic , strong) NSMutableArray *SPTitleArray;
@property (nonatomic, strong) UICollectionView *mianCollectionView;
@property (nonatomic,retain) SMVerticalSegmentedControl *segmentedControl;
/// 搜索
@property (strong, nonatomic) UITextField *searchText;
@property (nonatomic , assign) NSInteger qwe;
@end

@implementation ClassifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setReadView];
    // 获取导航栏
    [self loadsection];
    //设置默认的选中按钮
    if (self.abc == 0) {
        self.segmentedControl.selectedSegmentIndex = self.qwe;
    } else {
        self.segmentedControl.selectedSegmentIndex = self.abc;
    }
    [self.mianCollectionView reloadData];
    self.tabBarController.tabBar.hidden = NO;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = XZYSBackBColor;
    self.mianCollectionView.backgroundColor = [UIColor clearColor];
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    //添加导航栏品牌
//    UIView *pinView = [[UIView alloc] initWithFrame:CGRectMake(1, 64, 77, 45)];
    UIButton *labt = [UIButton buttonWithType:UIButtonTypeCustom];
    labt.frame = CGRectMake(1, 70, 76, 45);
    labt.backgroundColor = [UIColor whiteColor];
    [labt setTitle:@"品牌" forState:UIControlStateNormal];
    [labt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    labt.titleLabel.font = [UIFont systemFontOfSize:16];
    [labt addTarget:self action:@selector(pinPai) forControlEvents:UIControlEventTouchUpInside];
//    [pinView addSubview:labt];
    [self.view addSubview:labt];
    [self setNavigation];
    // 获取数据
    [self loadDatas];
    //创建UICollectionView
    [self createCollectionView];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)pinPai {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"该类商品尚未上架，敬请期待";
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

#pragma mark - 界面区
- (void)setNavigation {
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    backImageView.image = [UIImage imageNamed:@"index_01.jpg"];
    backImageView.userInteractionEnabled = YES;
    
    UIButton *BButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BButton.frame = CGRectMake(5, 7, 30, 40);
    [BButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [BButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:BButton];
    
    MButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
     HomeViewController *classVC = [[HomeViewController alloc] init];
//    [self.navigationController popToRootViewControllerAnimated:NO];
     [self.tabBarController setSelectedIndex:0];
     [self.tabBarController.navigationController pushViewController:classVC animated:YES];
}

#pragma mark -  消息
- (void)messageButtonClick:(UIButton *)sender {
    XiTongViewController *messageVC = [[XiTongViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

//创建segment
//创建垂直的segment
-(void)loadSegment{
    
    //实例化segment
    self.segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:allkeys];
    //设置背景颜色
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    //设置类型
    self.segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorThickness = 4;
    //  左侧 设置frame
    [self.segmentedControl setFrame:CGRectMake(1, 115, 76, NVNum * 45)];
    //添加segment
    [self.view addSubview:self.segmentedControl];
    //调用block
    [self.segmentedControl indexChangeBlock:^(NSInteger index) {
        [self indexChangeBlock:index];
    }];
    //设置默认的选中按钮
    self.segmentedControl.selectedSegmentIndex = self.abc;
}

//创建UICollectionView
-(void)createCollectionView{
    
    //创建布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置单元格的大小
    layout.itemSize = CGSizeMake(((SCREEN_WIDTH - 108) / 3) - 2, ((SCREEN_WIDTH - 108) / 3) + 30);
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //创建UICollectionView
    self.mianCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(76, 70, SCREEN_WIDTH - 76, SCREEN_HEIGHT-123) collectionViewLayout:layout];
    //设置代理和数据源协议
    self.mianCollectionView.dataSource = self;
    self.mianCollectionView.delegate = self;
    self.mianCollectionView.backgroundColor = [UIColor clearColor];
    
    //添加到视图控制器上
    [self.view addSubview:self.mianCollectionView];
    UIButton *qweButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qweButton.frame = CGRectMake(SCREEN_WIDTH - 160, 8, 80, 20);
    [qweButton setTitle:@"查看全部>>" forState:UIControlStateNormal];
    [qweButton setTitleColor:XZYSRGBColor(239, 124, 180) forState:UIControlStateNormal];
    qweButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [qweButton addTarget:self action:@selector(qweClock:) forControlEvents:UIControlEventTouchUpInside];
    [self.mianCollectionView addSubview:qweButton];
    
    //注册单元格
    [self.mianCollectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    
    //注册组头视图
    [self.mianCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}


//设置头视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 30);
}

//设置组头图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //创建头视图
    UICollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    //添加label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, 80, 20)];
    label.font = [UIFont systemFontOfSize:16];
    
    label.text = sectionTitleArray[indexPath.section];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = XZYSBlueColor;
    label.backgroundColor = XZYSBackBColor;
    //添加到头视图上
    [headerCell addSubview:label];
    
    return headerCell;
}

//按钮改变时调用
-(void)indexChangeBlock:(NSInteger)index{
    self.qwe = index;
    FLModel *model = [[FLModel alloc] init];
    model = FCidArray[index];
    _URLStr = [NSMutableString stringWithFormat:@"%@%@", XZYS_FLZDH_URL, model.cid];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    // 获取导航栏
    [self loadsection];
}


//实现数据源协议中的方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return sectionTitleArray.count;
}

//返回每个组中的元素个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSMutableArray *arr = rowmodelArray[section];
    return arr.count;

}

//创建单元格
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    NSArray *arr = rowmodelArray[indexPath.section];
    cell.oneModel = arr[indexPath.row];
    
    return cell;
}

//距离四周的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(6, 6, 6, 6);
}

#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    pushAllDetailsArray = [NSMutableArray array];
    [pushAllDetailsArray removeAllObjects];
    [[AFHTTPSessionManager manager] GET:XZYS_FLQBDH_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        NSString *flkey = [NSString string];
        //for in 遍历 获取数据源
        for (NSDictionary *dic in dataArray) {
            //获取数据源
            NSArray *subcategories = [dic objectForKey:@"cate_list"];
            for (NSDictionary *dic1 in subcategories) {
                NSMutableArray *arr = [NSMutableArray array];
                flkey = [dic1 objectForKey:@"title"];
                // 底层的字典数组
                NSArray *subcategories1 = [dic1 objectForKey:@"cate_list"];
                for (NSDictionary *dicti in subcategories1) {
                    //初始化Model
                    FLModel *oneModel = [[FLModel alloc] init];
                    [oneModel setValuesForKeysWithDictionary:dicti];
                    [arr addObject:oneModel];
                }
                [sectionTitleArray addObject:flkey];
                [rowmodelArray addObject:arr];
            }
        }
        // 隐藏指示器
        [SVProgressHUD dismiss];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
}

//获取数据
- (void)loadsection {
    if (_URLStr == nil) {
        _URLStr = @"http://www.xiezhongyunshang.com/App/GoodsCate/goodsCateSon/cid/1";
    }
    sectionTitleArray = [NSMutableArray array];
    [sectionTitleArray removeAllObjects];
    rowmodelArray = [NSMutableArray array];
    [rowmodelArray removeAllObjects];
    [[AFHTTPSessionManager manager] GET:_URLStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *NVArray = responseObject[@"data"];
        NSString *flkey = [NSString string];
        
        //获取数据源
        for (NSDictionary *dic1 in NVArray) {
            NSMutableArray *arr = [NSMutableArray array];
            flkey = [dic1 objectForKey:@"title"];
            // 底层的字典数组
            NSArray *subcategories1 = [dic1 objectForKey:@"cate_list"];
            for (NSDictionary *dicti in subcategories1) {
                //初始化Model
                FLModel *oneModel = [[FLModel alloc] init];
                [oneModel setValuesForKeysWithDictionary:dicti];
                [arr addObject:oneModel];
            }
            [sectionTitleArray addObject:flkey];
            [rowmodelArray addObject:arr];
        }
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
        [self.mianCollectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
    
}

-(void)loadDatas{
    //初始化数据源数组
    FCidArray = [NSMutableArray array];
    dataArr = [NSMutableArray array];
    dataDic = [NSMutableDictionary dictionary];
    allkeys = [NSMutableArray array];
    [FCidArray removeAllObjects];
    [dataArr removeAllObjects];
    [dataDic removeAllObjects];
    [allkeys removeAllObjects];
    
    sectionTitleArray = [NSMutableArray array];
    [sectionTitleArray removeAllObjects];
    rowmodelArray = [NSMutableArray array];
    [rowmodelArray removeAllObjects];
    
    [[AFHTTPSessionManager manager] GET:XZYS_FLSPDH_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *NVArray = responseObject[@"data"];
        NVNum = NVArray.count;
        for (NSDictionary *dic in NVArray) {
            FLModel *model = [[FLModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            NSString *key = [dic objectForKey:@"title"];
            [allkeys addObject:key];
            [FCidArray addObject:model];
        }
        
        //创建segment
        [self loadSegment];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"dianji:%ld", (long)indexPath.row);
    
    ShowAllViewController *XXVC = [[ShowAllViewController alloc] init];
    FLModel *model = [[FLModel alloc] init];
    NSArray *arr = rowmodelArray[indexPath.section];
    model = arr[indexPath.row];
    XXVC.lanmuID = model.cid;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:XXVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


/// 查看全部
- (void)qweClock:(UIButton *)sender {
    [self requestAllData];
    ShowAllViewController *showVC = [[ShowAllViewController alloc] init];
    if (self.abc == 0) {
        showVC.orderID = [NSString stringWithFormat:@"%ld", self.qwe + 1];
    } else {
        showVC.orderID = [NSString stringWithFormat:@"%d", self.abc + 1];
    }
    showVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showVC animated:YES];
    
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
