//
//  ClassifyViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ClassifyViewController.h"
#import "SMVerticalSegmentedControl.h"
#import "ShopModel.h"
#import "FLModel.h"
#import "ShopCollectionViewCell.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_Other.h"
#import "XZYS_URL.h"
#import "MessageViewController.h"
#import "SearchViewController.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import "ShowAllViewController.h"
#import "HomeViewController.h"

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
    NSInteger ID;
    NSInteger NVNum;
    NSMutableArray *pushAllDetailsArray;
}

@property (nonatomic, strong) NSString *URLStr;
@property (nonatomic, strong) UICollectionView *mianCollectionView;
@property (nonatomic,retain) SMVerticalSegmentedControl *segmentedControl;
/// 搜索
@property (strong, nonatomic) UIImageView *searchIamgeView;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = XZYSBackBColor;
    self.mianCollectionView.backgroundColor = [UIColor clearColor];
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    //添加导航栏品牌
    UIView *pinView = [[UIView alloc] initWithFrame:CGRectMake(1, 64, 77, 45)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 75, 43)];
    lab.backgroundColor = [UIColor whiteColor];
    lab.text = @"品牌";
    lab.textAlignment = NSTextAlignmentCenter;
    [pinView addSubview:lab];
    [self.view addSubview:pinView];
    
    [self setNavigation];
    // 获取数据
    [self loadDatas];
    //创建UICollectionView
    [self createCollectionView];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
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
    
    UIButton *MButton = [UIButton buttonWithType:UIButtonTypeCustom];
    MButton.frame = CGRectMake(SCREEN_WIDTH - 35, 10, 25, 25);
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
//    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    [self.navigationController pushViewController:homeVC animated:NO];
}


#pragma mark -  消息
- (void)messageButtonClick:(UIButton *)sender {
    MessageViewController *messageVC = [[MessageViewController alloc] init];
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
    [self.segmentedControl setFrame:CGRectMake(1, 109, 76, NVNum * 45)];
    //添加segment
    [self.view addSubview:self.segmentedControl];
    //调用block
    [self.segmentedControl indexChangeBlock:^(NSInteger index) {
        [self indexChangeBlock:index];
    }];
    //设置默认的选中按钮
    self.segmentedControl.selectedSegmentIndex = 0;
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
    self.mianCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(76, 64, SCREEN_WIDTH - 76, SCREEN_HEIGHT-117) collectionViewLayout:layout];
    //设置代理和数据源协议
    self.mianCollectionView.dataSource = self;
    self.mianCollectionView.delegate = self;
    self.mianCollectionView.backgroundColor = [UIColor clearColor];
    
    //添加到视图控制器上
    [self.view addSubview:self.mianCollectionView];
    UIButton *qweButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qweButton.frame = CGRectMake(SCREEN_WIDTH - 145, 8, 60, 20);
    [qweButton setTitle:@"查看全部>>" forState:UIControlStateNormal];
    [qweButton setTitleColor:XZYSRGBColor(239, 124, 180) forState:UIControlStateNormal];
    qweButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [qweButton addTarget:self action:@selector(qweClock:) forControlEvents:UIControlEventTouchUpInside];
    [self.mianCollectionView addSubview:qweButton];
    
    //注册单元格
    [self.mianCollectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    
    //注册组头视图
    [self.mianCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}


//设置头视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 26);
}

//设置组头图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //创建头视图
    UICollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    //添加label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, 80, 20)];
    label.font = [UIFont systemFontOfSize:14];
    
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
    ID = index;
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
        [self.mianCollectionView reloadData];
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
        [self.mianCollectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/GoodsCate/goodsCateSon/cid/1" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        
        [self.mianCollectionView reloadData];
        // 隐藏指示器
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"dianji:%ld", (long)indexPath.row);
    
}

/// 查看全部
- (void)qweClock:(UIButton *)sender {
    [self requestAllData];
    ShowAllViewController *showVC = [[ShowAllViewController alloc] init];
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
