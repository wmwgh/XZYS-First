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
#import <MBProgressHUD.h>
#import "OneTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "XIangQingViewController.h"
#import "SDFQModel.h"
#import "ShaiXuanViewCell.h"
#import "ShaiXuanHeaderView.h"
#import "PickerViewHeaderView.h"
#import "ZQViewCell.h"
#import "CZViewCell.h"
#import "NLViewCell.h"
#import "XGViewCell.h"
#import "JJViewCell.h"
#import "YSViewCell.h"
#import "FirstCollectionViewCell.h"

@interface ShowAllViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

/// 搜索
@property (strong , nonatomic) UITextField *searchText;
@property (nonatomic , strong) ShowAllDoubleView *rootView;
@property (nonatomic ,strong) NSMutableArray *allDataArray;
@property (nonatomic , strong) ShaiXuanHeaderView *firstHeaderView;
@property (nonatomic , strong) UIButton *MButton;
@property (nonatomic , strong) UIButton *priceButton;
@property (nonatomic , strong) UIButton *priceButton1;
@property (nonatomic , strong) UIButton *timeButton;
@property (nonatomic , strong) UIButton *numButton;
@property (nonatomic , copy) NSString *picStr;
@property (nonatomic , strong) UIView *cellView;
@property (nonatomic , strong) UIImageView *image1;
@property (nonatomic , strong) UITableView *mainTableView;
@property (nonatomic , strong) NSMutableDictionary *param;
@property (nonatomic , strong) UICollectionView *shaiXuanCollection;
@property (nonatomic , strong) UIView *pickerBackView;
@property (nonatomic , strong) UIView *underView;
@property (nonatomic, strong) UICollectionViewFlowLayout *myFlowLayout;

@property (nonatomic , copy) NSString *price1;
@property (nonatomic , copy) NSString *price2;
@property (nonatomic , strong) NSMutableArray *resultArray;
/** 选项标题数组 */
@property (strong, nonatomic) NSMutableArray *headerTitArr;
@property (strong, nonatomic) NSMutableArray *shrinkArr;
/** 专场 */
@property (strong, nonatomic) NSMutableArray *zhuanchang;
@property (strong, nonatomic) NSMutableArray *zhuanchangID;
@property (strong, nonatomic) NSMutableArray *zhuanchangCHN;
/** 专区*/
@property (strong, nonatomic) NSMutableArray *zhuanqu;
@property (strong, nonatomic) NSMutableArray *zhuanquID;
@property (strong, nonatomic) NSMutableArray *zhuanquCHN;
/** 材质 */
@property (strong, nonatomic) NSMutableArray *caizhi;
@property (strong, nonatomic) NSMutableArray *caizhiID;
@property (strong, nonatomic) NSMutableArray *caizhiCHN;
/** 内里 */
@property (strong, nonatomic) NSMutableArray *neili;
@property (strong, nonatomic) NSMutableArray *neiliID;
@property (strong, nonatomic) NSMutableArray *neiliCHN;
/** 鞋跟 */
@property (strong, nonatomic) NSMutableArray *xigen;
@property (strong, nonatomic) NSMutableArray *xigenID;
@property (strong, nonatomic) NSMutableArray *xigenCHN;
/** 季节 */
@property (strong, nonatomic) NSMutableArray *jijie;
@property (strong, nonatomic) NSMutableArray *jijieID;
@property (strong, nonatomic) NSMutableArray *jijieCHN;
/** 颜色 */
@property (strong, nonatomic) NSMutableArray *yanse;
@property (strong, nonatomic) NSMutableArray *yanseID;
@property (strong, nonatomic) NSMutableArray *yanseCHN;

@property (strong, nonatomic) NSMutableArray *ar1;
@property (strong, nonatomic) NSMutableArray *ar2;
@property (strong, nonatomic) NSMutableArray *ar3;
@property (strong, nonatomic) NSMutableArray *ar4;
@property (strong, nonatomic) NSMutableArray *ar5;
@property (strong, nonatomic) NSMutableArray *ar6;
@property (strong, nonatomic) NSMutableArray *ar7;

@property (strong, nonatomic) NSArray *ar11;
@property (strong, nonatomic) NSArray *ar22;
@property (strong, nonatomic) NSArray *ar33;
@property (strong, nonatomic) NSArray *ar44;
@property (strong, nonatomic) NSArray *ar55;
@property (strong, nonatomic) NSArray *ar66;
@property (strong, nonatomic) NSArray *ar77;

@property (nonatomic , copy) NSString *str1;
@property (nonatomic , copy) NSString *str2;
@property (nonatomic , copy) NSString *str3;
@property (nonatomic , copy) NSString *str4;
@property (nonatomic , copy) NSString *str5;
@property (nonatomic , copy) NSString *str6;
@property (nonatomic , copy) NSString *str7;
@end

@implementation ShowAllViewController
static NSString *const identifier_cell = @"identifier_cell";

- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}
- (NSMutableArray *)yanse {
    if (!_yanse) {
        _yanse = [NSMutableArray array];
    }
    return _yanse;
}
- (NSMutableArray *)jijie {
    if (!_jijie) {
        _jijie = [NSMutableArray array];
    }
    return _jijie;
}
- (NSMutableArray *)xigen {
    if (!_xigen) {
        _xigen = [NSMutableArray array];
    }
    return _xigen;
}
- (NSMutableArray *)caizhi {
    if (!_caizhi) {
        _caizhi = [NSMutableArray array];
    }
    return _caizhi;
}
- (NSMutableArray *)shrinkArr {
    if (!_shrinkArr) {
        _shrinkArr = [NSMutableArray array];
    }
    return _shrinkArr;
}
- (NSMutableArray *)zhuanqu {
    if (!_zhuanqu) {
        _zhuanqu = [NSMutableArray array];
    }
    return _zhuanqu;
}
- (NSMutableArray *)zhuanchang {
    if (!_zhuanchang) {
        _zhuanchang = [NSMutableArray array];
    }
    return _zhuanchang;
}
- (NSMutableArray *)neili {
    if (!_neili) {
        _neili = [NSMutableArray array];
    }
    return _neili;
}

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _picStr = @"qh_01";
    self.cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 157)];
    [self requestSXData];
    self.headerTitArr = [NSMutableArray arrayWithObjects:@"价格区间", @"专场", @"专区", @"材质", @"内里", @"鞋跟", @"季节", @"颜色", nil];
    for (int i = 0; i < self.headerTitArr.count; i++) {
        [self.shrinkArr addObject:@"NO"];
    }
    [self.view addSubview:self.cellView];
    // Do any additional setup after loading the view from its nib.
    [self requestAllData];
    [self setNavigation];
    [self setCollectionView];
    [self setShaiXuanView];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(zcCallBack:)
                                                 name:@"zcBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(zqCallBack:)
                                                 name:@"zqBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(czCallBack:)
                                                 name:@"czBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nlCallBack:)
                                                 name:@"nlBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xgCallBack:)
                                                 name:@"xgBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jjCallBack:)
                                                 name:@"jjBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ysCallBack:)
                                                 name:@"ysBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jgCallBack:)
                                                 name:@"jgBt"
                                               object:nil];
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
}

- (void)searchRequest {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [weakSelf.allDataArray removeAllObjects];
    
    if (weakSelf.str1 != nil) {
        dic[@"app_space_id"] = weakSelf.str1;
    }
    if (weakSelf.str2 != nil) {
        dic[@"app_model_id"] = weakSelf.str2;
    }
    if (weakSelf.str3 != nil) {
        dic[@"material_id"] = weakSelf.str3;
    }
    if (weakSelf.str4 != nil) {
        dic[@"linmater_id"] = weakSelf.str4;
    }
    if (weakSelf.str5 != nil) {
        dic[@"heel_id"] = weakSelf.str5;
    }
    if (weakSelf.str6 != nil) {
        dic[@"season_id"] = weakSelf.str6;
    }
    if (weakSelf.str7 != nil) {
        dic[@"color_id"] = weakSelf.str7;
    }
    if (weakSelf.price1 != nil) {
        dic[@"start_price"] = weakSelf.price1;
    }
    if (weakSelf.price2 != nil) {
        dic[@"end_price"] = weakSelf.price2;
    }
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
            [self.mainTableView reloadData];
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
}

- (void)zcCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.str1 = self.zhuanchangID[tagID];
    for (UIButton *bt in self.zhuanchang) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else if (bt.tag != tagID) {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}
- (void)zqCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.str2 = self.zhuanquID[tagID];
    for (UIButton *bt in self.zhuanqu) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else if (bt.tag != tagID) {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}
- (void)czCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.str3 = self.caizhiID[tagID];
    for (UIButton *bt in self.caizhi) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else if (bt.tag != tagID) {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}
- (void)nlCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.str4 = self.neiliID[tagID];
    for (UIButton *bt in self.neili) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else if (bt.tag != tagID) {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}
- (void)xgCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.str5 = self.xigenID[tagID];
    for (UIButton *bt in self.xigen) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else if (bt.tag != tagID) {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}
- (void)jjCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.str6 = self.jijieID[tagID];
    for (UIButton *bt in self.jijie) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else if (bt.tag != tagID) {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}
- (void)ysCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.str7 = self.yanseID[tagID];
    for (UIButton *bt in self.yanse) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else if (bt.tag != tagID) {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}
- (void)jgCallBack:(NSNotification *)text {
    NSDictionary *dic = text.userInfo[@"sid"];
    self.price1 = dic[@"1"];
    self.price2 = dic[@"2"];
    NSLog(@"%@-%@", self.price1, self.price2);
}

- (void)setTableView {
    [self.rootView.collectionView removeFromSuperview];
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 6, SCREEN_WIDTH, SCREEN_HEIGHT - 106)];
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
    SDFQModel *model = [[SDFQModel alloc] init];
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
    cell.numLabel.textColor = XZYSPinkColor;
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XIangQingViewController *XXVC = [[XIangQingViewController alloc] init];
    SDFQModel *model = [[SDFQModel alloc] init];
    model = self.allDataArray[indexPath.row];
    XXVC.model = model;
    XXVC.passID = model.goods_id;
    XXVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:XXVC animated:YES];
    [self.mainTableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
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

- (void)setCollectionb {
    [self.mainTableView removeFromSuperview];
    self.rootView = [[ShowAllDoubleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70)];
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
    if ([collectionView isEqual:self.shaiXuanCollection]) {
        return self.headerTitArr.count;
    }
    return 1;
}

// 设置每个分区里面有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.rootView.collectionView]) {
        return self.allDataArray.count;
    }
    if ([collectionView isEqual:self.shaiXuanCollection]) {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return self.ar11.count;
        } else if (section == 2) {
            return self.ar22.count;
        } else if (section == 3) {
            return self.ar33.count;
        } else if (section == 4) {
            return self.ar44.count;
        } else if (section == 5) {
            return self.ar55.count;
        } else if (section == 6) {
            return self.ar66.count;
        } else if (section == 7) {
            return self.ar77.count;
        }
    }
    return 0;
}

// 返回每一个item的cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.rootView.collectionView]) {
        // 第二步：重用cell
        RootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_cell forIndexPath:indexPath];
        cell.twoModel = self.allDataArray[indexPath.row];
        return cell;
    }
    if ([collectionView isEqual:self.shaiXuanCollection]) {
        if (indexPath.section == 0) {
            FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell0" forIndexPath:indexPath];
            cell.firstText.text = @"0";
            cell.secondText.text = @"500";
            return cell;
        } else if (indexPath.section == 1) {
            ShaiXuanViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
            NSString *str = self.ar11[indexPath.row];
            [cell.colorBtn setTitle:str forState:UIControlStateNormal];
            cell.colorBtn.tag = indexPath.row + 1000;
            [self.zhuanchang addObject:cell.colorBtn];
            return cell;
        } else if (indexPath.section == 2) {
            ZQViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
            NSString *str = self.ar22[indexPath.row];
            [cell.colorBtn setTitle:str forState:UIControlStateNormal];
            cell.colorBtn.tag = indexPath.row + 1000;
            [self.zhuanqu addObject:cell.colorBtn];
            return cell;
        } else if (indexPath.section == 3) {
            CZViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell3" forIndexPath:indexPath];
            NSString *str = self.ar33[indexPath.row];
            [cell.colorBtn setTitle:str forState:UIControlStateNormal];
            cell.colorBtn.tag = indexPath.row + 1000;
            [self.caizhi addObject:cell.colorBtn];
            return cell;
        } else if (indexPath.section == 4) {
            NLViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell4" forIndexPath:indexPath];
            NSString *str = self.ar44[indexPath.row];
            [cell.colorBtn setTitle:str forState:UIControlStateNormal];
            cell.colorBtn.tag = indexPath.row + 1000;
            [self.neili addObject:cell.colorBtn];
            return cell;
        } else if (indexPath.section == 5) {
            XGViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell5" forIndexPath:indexPath];
            NSString *str = self.ar55[indexPath.row];
            [cell.colorBtn setTitle:str forState:UIControlStateNormal];
            cell.colorBtn.tag = indexPath.row + 1000;
            [self.xigen addObject:cell.colorBtn];
            return cell;
        } else if (indexPath.section == 6) {
            JJViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell6" forIndexPath:indexPath];
            NSString *str = self.ar66[indexPath.row];
            [cell.colorBtn setTitle:str forState:UIControlStateNormal];
            cell.colorBtn.tag = indexPath.row + 1000;
            [self.jijie addObject:cell.colorBtn];
            return cell;
        } else if (indexPath.section == 7) {
            YSViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell7" forIndexPath:indexPath];
            NSString *str = self.ar77[indexPath.row];
            [cell.colorBtn setTitle:str forState:UIControlStateNormal];
            cell.colorBtn.tag = indexPath.row + 1000;
            [self.yanse addObject:cell.colorBtn];
            return cell;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.shaiXuanCollection]) {
        if (indexPath.section == 0) {
            CGSize itsize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 70, 25);
            return itsize;
        } else {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width / 5, 25);
        }
    } else if ([collectionView isEqual:self.rootView.collectionView]) {
        return CGSizeMake(self.view.bounds.size.width / 2 - 4, self.view.bounds.size.width / 2 + 60);
    }
    CGSize size = {0,0};
    return size;
}
// 返回头视图和尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PickerViewHeaderView *firstHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"picke" forIndexPath:indexPath];
        firstHeaderView.headerLabel.text = self.headerTitArr[indexPath.section];
        firstHeaderView.headerLabel.font = [UIFont systemFontOfSize:15];
        firstHeaderView.headerLabel.textColor = XZYSBlueColor;
        return firstHeaderView;
    } else {
        self.firstHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"pick" forIndexPath:indexPath];
        self.firstHeaderView.headerLabel.text = self.headerTitArr[indexPath.section];
        self.firstHeaderView.headerLabel.font = [UIFont systemFontOfSize:15];
        [self.firstHeaderView.sectionButton setTitle:@"全部" forState:UIControlStateNormal];
        self.firstHeaderView.sectionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.firstHeaderView.sectionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.firstHeaderView.headerLabel.textColor = XZYSBlueColor;
        [self.firstHeaderView.sectionButton addTarget:self action:@selector(allBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.firstHeaderView.sectionImg.tag = indexPath.section;
        self.firstHeaderView.sectionButton.tag = indexPath.section;
        if (indexPath.section > 0) {
            if ([self.shrinkArr[indexPath.section] isEqualToString:@"NO"]) {
                self.firstHeaderView.sectionImg.image = [UIImage imageNamed:@"sx_sjta"];
            }else {
                self.firstHeaderView.sectionImg.image = [UIImage imageNamed:@"sx_xjtb"];
                
            }
        }
        return self.firstHeaderView;
    }
    return nil;
}

- (void)allBtn:(UIButton *)sender {
    if ([self.shrinkArr[sender.tag] isEqualToString:@"NO"]) {
        if (sender.tag == 0) {
            self.ar11 = self.zhuanchangCHN;
        }
        if (sender.tag == 1) {
            self.ar11 = self.zhuanchangCHN;
        } else if (sender.tag == 2) {
            self.ar22 = self.zhuanquCHN;
        } else if (sender.tag == 3) {
            self.ar33 = self.caizhiCHN;
        } else if (sender.tag == 4) {
            self.ar44 = self.neiliCHN;
        } else if (sender.tag == 5) {
            self.ar55 = self.xigenCHN;
        } else if (sender.tag == 6) {
            self.ar66 = self.jijieCHN;
        } else if (sender.tag == 7) {
            self.ar77 = self.yanseCHN;
        }
        
        [self.shrinkArr replaceObjectAtIndex:sender.tag withObject:@"YES"];
    }else {
        if (sender.tag == 0) {
            self.ar11 = self.ar1;
        }
        if (sender.tag == 1) {
            self.ar11 = self.ar1;
        } else if (sender.tag == 2) {
            self.ar22 = self.ar2;
        } else if (sender.tag == 3) {
            self.ar33 = self.ar3;
        } else if (sender.tag == 4) {
            self.ar44 = self.ar4;
        } else if (sender.tag == 5) {
            self.ar55 = self.ar5;
        } else if (sender.tag == 6) {
            self.ar66 = self.ar6;
        } else if (sender.tag == 7) {
            self.ar77 = self.ar7;
        }

        [self.shrinkArr replaceObjectAtIndex:sender.tag withObject:@"NO"];
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sender.tag];
    [self.shaiXuanCollection reloadSections:indexSet];

}

#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    _allDataArray = [NSMutableArray array];
    [_allDataArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:XZYS_ALL_URL parameters:weakSelf.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@", responseObject);
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        
        for (NSDictionary *dic in dataArray) {
            SDFQModel *model = [[SDFQModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [weakSelf.allDataArray addObject:model];
        }
        
        [self.rootView.collectionView reloadData];
        [self.mainTableView reloadData];
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
}

- (void)setNavigation {
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    backImageView.image = [UIImage imageNamed:@"index_01.jpg"];
    backImageView.userInteractionEnabled = YES;
    
    UIButton *BButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BButton.frame = CGRectMake(5, 6, 30, 40);
    [BButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [BButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:BButton];
    
    self.MButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.MButton.frame = CGRectMake(SCREEN_WIDTH - 32, 15, 20, 20);
    [self.MButton setImage:[UIImage imageNamed:_picStr] forState:UIControlStateNormal];
    
    [self.MButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:self.MButton];
    
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

    /// 添加选择按钮
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 36)];
    pickBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pickBackView];
    self.numButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numButton.frame = CGRectMake(0, 0, SCREEN_WIDTH / 4, 36);
    [self.numButton setTitle:@"销 量" forState:UIControlStateNormal];
    self.numButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [numButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    [self.numButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:self.numButton];
    
    self.priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priceButton.frame = CGRectMake(SCREEN_WIDTH / 4 - 15, 0, SCREEN_WIDTH / 4, 36);
    [self.priceButton setTitle:@"价 格" forState:UIControlStateNormal];
    self.image1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 37, 10, 8, 16)];
    self.image1.image = [UIImage imageNamed:@"lb_jtc"];
    [pickBackView addSubview:self.image1];
    self.priceButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.priceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.priceButton addTarget:self action:@selector(priceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:self.priceButton];
    
    self.priceButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priceButton1.frame = CGRectMake(SCREEN_WIDTH / 4 - 15, 0, SCREEN_WIDTH / 4, 36);
    [self.priceButton1 setTitle:@"价 格" forState:UIControlStateNormal];
    self.priceButton1.titleLabel.font = [UIFont systemFontOfSize: 16];
    self.priceButton1.hidden = YES;
    [self.priceButton1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.priceButton1 addTarget:self action:@selector(priceButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:self.priceButton1];
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timeButton.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 4, 36);
    [self.timeButton setTitle:@"时 间" forState:UIControlStateNormal];
//    [timeButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:self.timeButton];
    
    UIButton *sxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sxButton.frame = CGRectMake(SCREEN_WIDTH * 3 / 4, 0, SCREEN_WIDTH / 4, 36);
    [sxButton setTitleColor:XZYSBlueColor forState:UIControlStateSelected];
    sxButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [sxButton setTitle:@"筛 选" forState:UIControlStateNormal];
    [sxButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sxButton addTarget:self action:@selector(sxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickBackView addSubview:sxButton];
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
        [self setCollectionb];
        [self.rootView.collectionView reloadData];
    }

}

// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XIangQingViewController *XXVC = [[XIangQingViewController alloc] init];
    SDFQModel *model = [[SDFQModel alloc] init];
    model = self.allDataArray[indexPath.row];
    XXVC.model = model;
    XXVC.passID = model.goods_id;
    XXVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:XXVC animated:YES];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------- 筛选部分

- (void)setShaiXuanView {
    self.underView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.underView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.7];
    UIButton *backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBT addTarget:self action:@selector(backBTAction) forControlEvents:UIControlEventTouchUpInside];
    backBT.frame = self.view.bounds;
    backBT.backgroundColor = [UIColor clearColor];
    [self.underView addSubview:backBT];
    self.pickerBackView = [[UIView alloc] init];
    self.pickerBackView.alpha = 1;
    self.pickerBackView.frame = CGRectMake(70, 20, SCREEN_WIDTH - 70, SCREEN_HEIGHT - 20);
    self.pickerBackView.backgroundColor = [UIColor whiteColor];
    [self.underView addSubview:self.pickerBackView];
    [self.view addSubview:self.underView];
    // 创建对象并指定样式
    
    // 1.定义collectionView的样式
    self.myFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置属性
    // 给定item的大小
    self.myFlowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 5, 25);
    // 每两个item的最小间隙（垂直滚动）
    self.myFlowLayout.minimumInteritemSpacing = 5;
    // 每两个item的最小间隙（水平滚动方向）
    self.myFlowLayout.minimumLineSpacing = 5;
    
    // 设置滚动方向
    self.myFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;// 垂直方向
    self.myFlowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 30);
    self.myFlowLayout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
    
    self.shaiXuanCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.pickerBackView.frame.size.width, self.pickerBackView.frame.size.height - 45) collectionViewLayout:self.myFlowLayout];
    self.shaiXuanCollection.backgroundColor = [UIColor whiteColor];
//
    [self.pickerBackView addSubview:self.shaiXuanCollection];
//    // 设置代理
    self.shaiXuanCollection.dataSource = self;
    self.shaiXuanCollection.delegate = self;
//
//    // 第一步：注册cell
    [self.shaiXuanCollection registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell0"];
    [self.shaiXuanCollection registerNib:[UINib nibWithNibName:@"ShaiXuanViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell1"];
    [self.shaiXuanCollection registerNib:[UINib nibWithNibName:@"ZQViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell2"];
    [self.shaiXuanCollection registerNib:[UINib nibWithNibName:@"CZViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell3"];
    [self.shaiXuanCollection registerNib:[UINib nibWithNibName:@"NLViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell4"];
    [self.shaiXuanCollection registerNib:[UINib nibWithNibName:@"XGViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell5"];
    [self.shaiXuanCollection registerNib:[UINib nibWithNibName:@"JJViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell6"];
    [self.shaiXuanCollection registerNib:[UINib nibWithNibName:@"YSViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell7"];
    
    //   注册头视图
    [self.shaiXuanCollection registerClass:[ShaiXuanHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"pick"];
    [self.shaiXuanCollection registerClass:[PickerViewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"picke"];
    
    UIButton *addBT = [UIButton buttonWithType:UIButtonTypeCustom];
    addBT.titleLabel.font = [UIFont systemFontOfSize:14];
    addBT.frame = CGRectMake(0, CGRectGetMaxY(self.shaiXuanCollection.frame), self.pickerBackView.frame.size.width / 2, 45);
    [addBT setTitle:@"重置" forState:UIControlStateNormal];
    [addBT addTarget:self action:@selector(refreshbtn) forControlEvents:UIControlEventTouchUpInside];
    addBT.backgroundColor = XZYSRGBColor(234, 234, 234);
    [addBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.pickerBackView addSubview:addBT];
    UIButton *carBT = [UIButton buttonWithType:UIButtonTypeCustom];
    carBT.titleLabel.font = [UIFont systemFontOfSize:14];
    carBT.frame = CGRectMake(CGRectGetMaxX(addBT.frame), CGRectGetMaxY(self.shaiXuanCollection.frame), self.pickerBackView.frame.size.width / 2, 45);
    [carBT setTitle:@"确定" forState:UIControlStateNormal];
    [carBT addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside];
    carBT.backgroundColor = XZYSBlueColor;
    [self.pickerBackView addSubview:carBT];
    
    
    self.underView.hidden = YES;
}

- (void)refreshbtn {
    for (UIButton *bt in self.yanse) {
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.layer.borderWidth = 0;
        bt.backgroundColor = XZYSRGBColor(234, 234, 234);
    }
    for (UIButton *bt in self.zhuanqu) {
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.layer.borderWidth = 0;
        bt.backgroundColor = XZYSRGBColor(234, 234, 234);
    }
    for (UIButton *bt in self.zhuanchang) {
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.layer.borderWidth = 0;
        bt.backgroundColor = XZYSRGBColor(234, 234, 234);
    }
    for (UIButton *bt in self.neili) {
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.layer.borderWidth = 0;
        bt.backgroundColor = XZYSRGBColor(234, 234, 234);
    }
    for (UIButton *bt in self.jijie) {
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.layer.borderWidth = 0;
        bt.backgroundColor = XZYSRGBColor(234, 234, 234);
    }
    for (UIButton *bt in self.xigen) {
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.layer.borderWidth = 0;
        bt.backgroundColor = XZYSRGBColor(234, 234, 234);
    }
    for (UIButton *bt in self.caizhi) {
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.layer.borderWidth = 0;
        bt.backgroundColor = XZYSRGBColor(234, 234, 234);
    }
    self.str1 = nil;
    self.str2 = nil;
    self.str3 = nil;
    self.str4 = nil;
    self.str5 = nil;
    self.str6 = nil;
    self.str7 = nil;
}
- (void)sureBtn {
    self.resultArray = [NSMutableArray array];
    if (self.str1 != nil) {
        [self.resultArray addObject:self.str1];
    }
    if (self.str2 != nil) {
        [self.resultArray addObject:self.str2];
    }
    if (self.str3 != nil) {
        [self.resultArray addObject:self.str3];
    }
    if (self.str4 != nil) {
        [self.resultArray addObject:self.str4];
    }
    if (self.str5 != nil) {
        [self.resultArray addObject:self.str5];
    }
    if (self.str6 != nil) {
        [self.resultArray addObject:self.str6];
    }
    if (self.str7 != nil) {
        [self.resultArray addObject:self.str7];
    }
    NSLog(@"%@", self.resultArray);
    self.underView.hidden = YES;
    [self searchRequest];
}

- (void)backBTAction {
    self.underView.hidden = YES;
}

#pragma mark - 请求数据
- (void)requestSXData {
    __weak typeof(self) weakSelf = self;
    // 专区
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/AppSpecifications/getScreenModelList" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dataDic allKeys]];;
        NSInteger count = [allKeys count];
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                if([[allKeys objectAtIndex:j] compare:[allKeys objectAtIndex:j + 1] options:NSNumericSearch] == 1){
                    [allKeys exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        weakSelf.zhuanquCHN = [NSMutableArray array];
        weakSelf.zhuanquID = allKeys;
        for (NSString *ck in weakSelf.zhuanquID) {
            [weakSelf.zhuanquCHN addObject:dataDic[ck]];
        }
        [self requestZqData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}
- (void)requestZqData {
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/AppSpecifications/getScreenSpaceList" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dataDic allKeys]];;
        NSInteger count = [allKeys count];
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                if([[allKeys objectAtIndex:j] compare:[allKeys objectAtIndex:j + 1] options:NSNumericSearch] == 1){
                    [allKeys exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        weakSelf.zhuanchangCHN = [NSMutableArray array];
        weakSelf.zhuanchangID = allKeys;
        for (NSString *ck in weakSelf.zhuanchangID) {
            [weakSelf.zhuanchangCHN addObject:dataDic[ck]];
        }
        [self requestCzData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)requestCzData {
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/AppSpecifications/getAppSpecifications/specifications/material" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dataDic allKeys]];;
        NSInteger count = [allKeys count];
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                if([[allKeys objectAtIndex:j] compare:[allKeys objectAtIndex:j + 1] options:NSNumericSearch] == 1){
                    [allKeys exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        weakSelf.caizhiCHN = [NSMutableArray array];
        weakSelf.caizhiID = allKeys;
        for (NSString *ck in weakSelf.caizhiID) {
            [weakSelf.caizhiCHN addObject:dataDic[ck]];
        }
        [self requestNlData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)requestNlData {
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/AppSpecifications/getAppSpecifications/specifications/linmater" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dataDic allKeys]];;
        NSInteger count = [allKeys count];
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                if([[allKeys objectAtIndex:j] compare:[allKeys objectAtIndex:j + 1] options:NSNumericSearch] == 1){
                    [allKeys exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        weakSelf.neiliCHN = [NSMutableArray array];
        weakSelf.neiliID = allKeys;
        for (NSString *ck in weakSelf.neiliID) {
            [weakSelf.neiliCHN addObject:dataDic[ck]];
        }
        [self requestXgData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)requestXgData {
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/AppSpecifications/getAppSpecifications/specifications/heel" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dataDic allKeys]];;
        NSInteger count = [allKeys count];
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                if([[allKeys objectAtIndex:j] compare:[allKeys objectAtIndex:j + 1] options:NSNumericSearch] == 1){
                    [allKeys exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        weakSelf.xigenCHN = [NSMutableArray array];
        weakSelf.xigenID = allKeys;
        for (NSString *ck in weakSelf.xigenID) {
            [weakSelf.xigenCHN addObject:dataDic[ck]];
        }
        [self requestJjData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)requestJjData {
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/AppSpecifications/getAppSpecifications/specifications/season" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dataDic allKeys]];;
        NSInteger count = [allKeys count];
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                if([[allKeys objectAtIndex:j] compare:[allKeys objectAtIndex:j + 1] options:NSNumericSearch] == 1){
                    [allKeys exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        weakSelf.jijieCHN = [NSMutableArray array];
        weakSelf.jijieID = allKeys;
        for (NSString *ck in weakSelf.jijieID) {
            [weakSelf.jijieCHN addObject:dataDic[ck]];
        }
        [self requestYsData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)requestYsData {
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/AppSpecifications/getAppSpecifications/specifications/color" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dataDic allKeys]];;
        NSInteger count = [allKeys count];
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                if([[allKeys objectAtIndex:j] compare:[allKeys objectAtIndex:j + 1] options:NSNumericSearch] == 1){
                    [allKeys exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        weakSelf.yanseCHN = [NSMutableArray array];
        weakSelf.yanseID = allKeys;
        for (NSString *ck in weakSelf.yanseID) {
            [weakSelf.yanseCHN addObject:dataDic[ck]];
        }
        self.ar1 = [NSMutableArray array];
        self.ar2 = [NSMutableArray array];
        self.ar3 = [NSMutableArray array];
        self.ar4 = [NSMutableArray array];
        self.ar5 = [NSMutableArray array];
        self.ar6 = [NSMutableArray array];
        self.ar7 = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            [self.ar1 addObject:self.zhuanchangCHN[i]];
            [self.ar2 addObject:self.zhuanquCHN[i]];
            [self.ar3 addObject:self.caizhiCHN[i]];
            [self.ar4 addObject:self.neiliCHN[i]];
            [self.ar5 addObject:self.xigenCHN[i]];
            [self.ar6 addObject:self.jijieCHN[i]];
            [self.ar7 addObject:self.yanseCHN[i]];
        }
        self.ar11 = self.ar1;
        self.ar22 = self.ar2;
        self.ar33 = self.ar3;
        self.ar44 = self.ar4;
        self.ar55 = self.ar5;
        self.ar66 = self.ar6;
        self.ar77 = self.ar7;
        [self.shaiXuanCollection reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
