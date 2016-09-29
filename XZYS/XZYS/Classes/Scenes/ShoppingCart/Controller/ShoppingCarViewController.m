//
//  ShoppingCarViewController.m
//  ZDCar
//
//  Created by yangxuran on 16/7/22.
//  Copyright © 2016年 boc. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShopCarTableViewCell.h"
#import "CustomHeaderView.h"
#import "BottomView.h"
#import <MBProgressHUD.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "XZYS_Other.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AllGucModel.h"
#import "XIangQingViewController.h"
#import "ShopViewController.h"
#import <MJRefresh.h>
#import "ShopCarModel.h"

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height

@interface ShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarTableViewCellDelegate, CustomHeaderViewDelegate, BottomViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView * baseTable;
@property (nonatomic, strong) BottomView * bottomView;
@property (nonatomic, strong) BottomModel * bottomModel;
@property (nonatomic, strong) NSMutableArray * totalSelectedAry;
@property (nonatomic, strong) UIButton * rightTopBtn;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *allKeys;
@property (nonatomic , strong) NSMutableArray *idArray;
@property (nonatomic , strong) UILabel *labe;
@property (nonatomic , strong) NSMutableDictionary *jsonParam;
//测试
@property (nonatomic, copy)NSMutableString * testString;
@end

static NSString * indentifier = @"shopCarCell";
@implementation ShoppingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseTable];
    self.labe = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, SCREEN_WIDTH - 200, 30)];
    BottomView * bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, kHeight - 100, kWidth, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.delegate = self;
    self.bottomView = bottomView;
    [self.view addSubview:self.bottomView];
    self.bottomModel = [[BottomModel alloc] init];
    
    [self configerNavItemBtn];
//    [self configerData];
//    [self requestCartData];
    // 添加顶部刷新
    [self addRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callBack:)
                                                 name:@"titleCall"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textCallBack:)
                                                 name:@"textCall"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(minCallBack:)
                                                 name:@"minCall"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(plusCallBack:)
                                                 name:@"plusCall"
                                               object:nil];
}

- (void)addRefresh {
    self.baseTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestCartData)];
    [self.baseTable.mj_header beginRefreshing];
}

- (void)textCallBack:(NSNotification *)text {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    AppDelegate *appdele = [[UIApplication sharedApplication] delegate];
    param[@"uid"] = appdele.userIdTag;
    [param setValuesForKeysWithDictionary:text.userInfo];
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/cartItemNum" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *countStr = responseObject[@"data"];
        [self GetTotalBill];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (void)minCallBack:(NSNotification *)text {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    AppDelegate *appdele = [[UIApplication sharedApplication] delegate];
    param[@"uid"] = appdele.userIdTag;
    [param setValuesForKeysWithDictionary:text.userInfo];
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/cartItemMinus" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *countStr = responseObject[@"data"];
        [self GetTotalBill];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (void)plusCallBack:(NSNotification *)text {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    AppDelegate *appdele = [[UIApplication sharedApplication] delegate];
    param[@"uid"] = appdele.userIdTag;
    [param setValuesForKeysWithDictionary:text.userInfo];
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/cartItemPlus" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *countStr = responseObject[@"data"];
        [self GetTotalBill];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (void)callBack:(NSNotification *)text {
    ShopViewController *xxVC = [[ShopViewController alloc] init];
    xxVC.shopID = text.userInfo[@"sid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)requestCartData {
    self.dataArray = [NSMutableArray array];
    [self.dataArray removeAllObjects];
    self.allKeys = [NSMutableArray array];
    [self.allKeys removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    AppDelegate *appdele = [[UIApplication sharedApplication] delegate];
    param[@"uid"] = appdele.userIdTag;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/cart" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        if (!([dic count] == 0)) {
            NSArray *keyArray = [dic allKeys];
            [self.allKeys addObjectsFromArray:keyArray];
            for (NSString *key in self.allKeys) {
                NSDictionary *dict = dic[key];
                ShopCarModel *shopModel = [[ShopCarModel alloc] init];
                shopModel.shop_name = dict[@"shop_name"];
                shopModel.shop_id = key;
//                [self.shopNameArray addObject:dict[@"shop_name"]];
                NSMutableArray *arra = dict[@"cart_list"];
                NSMutableArray *dataAr = [NSMutableArray array];
                for (NSDictionary *diction in arra) {
                    AllGucModel *model = [[AllGucModel alloc] init];
                    [model setValuesForKeysWithDictionary:diction];
                    [dataAr addObject:model];
                }
                shopModel.listArr = dataAr;
                [self.dataArray addObject:shopModel];
            }
            [self.labe removeFromSuperview];
            self.bottomModel.isSelecteAll = NO;
            [self GetTotalBill];
            [self.baseTable.mj_header endRefreshing];
            [self.baseTable reloadData];
        } else {
            self.labe.text = @"购物车还没有添加商品";
            self.labe.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.labe];
            [self.baseTable.mj_header endRefreshing];
            [self GetTotalBill];//求和
            [self.baseTable reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(UITableView *)baseTable{
    if (_baseTable == nil) {
        _baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 50) style:UITableViewStyleGrouped];
        _baseTable.backgroundColor = [UIColor clearColor];
        _baseTable.dataSource = self;
        _baseTable.delegate = self;
        _baseTable.rowHeight = 100;
        [_baseTable registerNib:[UINib nibWithNibName:@"ShopCarTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
    }
    return _baseTable;
}


#pragma mark -- <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] listArr].count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CustomHeaderView *view = [[CustomHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    view.tag = section + 2000;
    view.delegate = self;
    ShopCarModel *model = self.dataArray[section];
    view.tittleBtn.tag = [model.shop_id intValue];
    [view setModel:model];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.delegate = self;
    ShopCarModel *shopModel = self.dataArray[indexPath.section];
    AllGucModel *model = shopModel.listArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopCarModel *shopModel = self.dataArray[indexPath.section];
    AllGucModel *model = shopModel.listArr[indexPath.row];
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    xxVC.passID = model.goods_id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.idArray = [NSMutableArray array];
    ShopCarModel *shopModel = self.dataArray[indexPath.section];
    NSArray *arr = shopModel.listArr;
    AllGucModel *model = arr[indexPath.row];
    [self.idArray addObject:model.ID];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.idArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strjson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    AppDelegate *appdele = [[UIApplication sharedApplication] delegate];
    param[@"uid"] = appdele.userIdTag;
    param[@"id"] = strjson;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/cartDel" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([str isEqualToString:@"-1202"]) {
            [self GetTotalBill];
            [self requestCartData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)configerNavItemBtn{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.rightTopBtn = btn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark --- cell代理方法(cell 左侧按钮)
- (void)clickedWichLeftBtn:(UITableViewCell *)cell{
    NSIndexPath * indexpath = [self.baseTable indexPathForCell:cell];
    ShopCarModel * shopCarModel = self.dataArray[indexpath.section];//当前选中的商品对应的店铺的模型
    AllGucModel *model = shopCarModel.listArr[indexpath.row];
    model.selected = !model.selected;
    NSInteger totalCount = 0;
    for (int i = 0; i < shopCarModel.listArr.count; i++) {
        AllGucModel * GwcShopModel = shopCarModel.listArr[i];
        if (GwcShopModel.selected) {
            totalCount++;
        }
    }
    ShopCarModel *sectionModel = self.dataArray[indexpath.section];
    sectionModel.isChecked = (totalCount == shopCarModel.listArr.count);
    
    [self checkShopState];
}

//修改数量
- (void)changeTheShopCount:(UITableViewCell *)cell count:(NSInteger )count{
    NSIndexPath *indexpath = [self.baseTable indexPathForCell:cell];
    ShopCarModel *shopCarModel = self.dataArray[indexpath.section];//当前选中的商品对应的店铺的模型
    AllGucModel *model = shopCarModel.listArr[indexpath.row];
    model.count = count;
    //    [self checkShopState];错误
    [self GetTotalBill];
}

#pragma mark --- CustomHeaderViewDelegate

- (void)clickedWhichHeaderView:(NSInteger)index{
    NSInteger sectionIndex = index - 2000;
    ShopCarModel *model = self.dataArray[sectionIndex];
    model.isChecked = !model.isChecked;
    NSMutableArray * tempAry = [self.dataArray[sectionIndex] listArr];
    for (int i = 0; i < tempAry.count; i++) {
        AllGucModel *shopModel = tempAry[i];
        shopModel.selected = model.isChecked;
    }
    [self checkShopState];
}

#pragma mark --  BottomViewDelegate
-  (void)clickedBottomSelecteAll{//全选方法
    
    self.bottomModel.isSelecteAll = !self.bottomModel.isSelecteAll;
    for (int i = 0; i < self.dataArray.count; i++) {
        ShopCarModel * model = self.dataArray[i];
        model.isChecked = self.bottomModel.isSelecteAll;
        for (int j = 0; j < model.listArr.count; j++) {
            AllGucModel *shopModel = model.listArr[j];
            shopModel.selected = self.bottomModel.isSelecteAll;
        }
    }
    self.bottomView.model = self.bottomModel;
    [self GetTotalBill];//求和
    [self.baseTable reloadData];
}

- (void)clickedBottomJieSuan{//结算方法
    if (self.bottomModel.isEdit) {
        if (self.bottomModel.totalCount == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择要删除的商品";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }else{
            [self warnMessage:@"是否确定要删除该商品"];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_totalSelectedAry options:NSJSONWritingPrettyPrinted error:nil];
            NSString *strjson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            self.jsonParam = [NSMutableDictionary dictionary];
            AppDelegate *appdele = [[UIApplication sharedApplication] delegate];
            self.jsonParam[@"uid"] = appdele.userIdTag;
            self.jsonParam[@"id"] = strjson;
            
            
        }
    }else{
        if (self.bottomModel.totalCount == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择结算商品";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }else{
            NSLog(@"选择了商品，进行结算，进入商品详情页面");
            NSLog(@"要传给下一个订单详情页面的数据模型是%@", _totalSelectedAry);
        }
    }
}

- (void)warnMessage:(NSString *)string{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //删除事件。多个删除直接重新请求数据！
        [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/cartDel" parameters:self.jsonParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            if ([str isEqualToString:@"-1202"]) {
                self.bottomModel.isSelecteAll = NO;
                [self GetTotalBill];
                [self requestCartData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}

#pragma mark -- 公共方法
//选中商品或者选中店铺都会走这个公共方法。在这里判断选中的店铺数量还不是和数据源数组数量相等。一样的话就全选，否则相反。
- (void)checkShopState{
    NSInteger totalSelected = 0;
    for (int i = 0; i < self.dataArray.count; i++) {
        ShopCarModel * model = self.dataArray[i];
        if (model.isChecked) {
            totalSelected++;
        }
    }
    if (totalSelected == self.dataArray.count) {
        self.bottomModel.isSelecteAll = YES;
    }else{
        self.bottomModel.isSelecteAll = NO;
    }
    self.bottomView.model = self.bottomModel;
    
    [self GetTotalBill];//求和
    [self.baseTable reloadData];
    
}

//求得总共费用
- (void)GetTotalBill{
    self.totalSelectedAry  = [NSMutableArray array];
    float totalMoney = 0.00;
    NSMutableString * compentStr = [[NSMutableString alloc] init];
    for (int i = 0; i < self.dataArray.count; i++) {
        ShopCarModel * model = self.dataArray[i];
        for (int j = 0; j < model.listArr.count; j++) {
            AllGucModel *shopModel = model.listArr[j];
            if (shopModel.selected) {
                //保存model。如果是结算，传递选中商品，确认订单页面展示。如果是删除，根据此数组，拿到商品ID，用来删除。
                [_totalSelectedAry addObject:shopModel.ID];
                [compentStr appendString:shopModel.goods_name];
                if (shopModel.count != 0) {
                    shopModel.num = [NSString stringWithFormat:@"%ld", shopModel.count];
                }
                totalMoney += [shopModel.price intValue] * [shopModel.num intValue];
            }
        }
    }
    if (self.dataArray.count == 0) {
        self.bottomModel.isSelecteAll = NO;
        self.bottomModel.isEdit = NO;
        [self.rightTopBtn setTitle:@"编辑"forState:UIControlStateNormal];
        self.bottomView.model = self.bottomModel;
    }
    self.testString = compentStr;//保存，测试用。
    self.bottomModel.totalMoney = totalMoney;
    self.bottomModel.totalCount = _totalSelectedAry.count;
    self.bottomView.model = self.bottomModel;
}


#pragma mark --- NavgationItemBtnClicked
- (void)editBtnClicked{
    self.isEditing = !self.isEditing;
    [self.rightTopBtn setTitle:self.isEditing ? @"完成" : @"编辑" forState:UIControlStateNormal];
    self.bottomModel.isEdit = self.isEditing;
    self.bottomView.model = self.bottomModel;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestCartData];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
}
@end
