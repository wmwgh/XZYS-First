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
#import "ShopCarModel.h"
#import "GwcShopModel.h"
#import <MBProgressHUD.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "XZYS_Other.h"

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height

@interface ShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarTableViewCellDelegate, CustomHeaderViewDelegate, BottomViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, strong)BottomView * bottomView;
@property (nonatomic, strong)BottomModel * bottomModel;
@property (nonatomic, strong)NSMutableArray * totalSelectedAry;
@property (nonatomic, strong)UIButton * rightTopBtn;
@property (nonatomic, assign)BOOL isEditing;
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
    
    BottomView * bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, kHeight - 100, kWidth, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.delegate = self;
    self.bottomView = bottomView;
    [self.view addSubview:self.bottomView];
    self.bottomModel = [[BottomModel alloc] init];
    
    [self configerNavItemBtn];
    [self configerData];
    [self requestData];
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

- (void)requestData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
#warning 需要UID
    param[@"uid"] = @"1";
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Cart/cart" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = responseObject[@"data"];
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)configerData{
    self.dataAry = [NSMutableArray array];
    NSMutableArray * tempAry = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        GwcShopModel * model = [[GwcShopModel alloc] init];
        model.shopTitle = [NSString stringWithFormat:@"这是商品%zd", i];
        model.singlePrice = (arc4random() % 300) + 100;
        model.count = arc4random() % 5 + 1;
        [tempAry addObject:model];
    }
    
    NSMutableArray * array1 = [NSMutableArray arrayWithObjects:tempAry[0],tempAry[1] ,nil];
    NSMutableArray * array2 = [NSMutableArray arrayWithObjects:tempAry[2],nil];
    NSMutableArray * array3 = [NSMutableArray arrayWithObjects:tempAry[3],tempAry[4] ,tempAry[5] ,nil];
    NSMutableArray * array4 = [NSMutableArray arrayWithObjects:tempAry[6],tempAry[7] ,nil];
    NSMutableArray *ary  =[NSMutableArray arrayWithObjects:array1, array2, array3, array4, nil];
    for (int i = 0; i < 4; i++) {
        ShopCarModel * model = [[ShopCarModel alloc] init];
        model.dianpuTitle = [NSString stringWithFormat:@"店铺名称%zd", i];
        model.listArr = ary[i];
        [self.dataAry addObject:model];
    }
    [self.baseTable reloadData];
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
    return self.dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataAry[section] listArr].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CustomHeaderView * view = [[CustomHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    view.tag = section + 2000;
    view.delegate = self;
    view.model = self.dataAry[section];
    return view;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    GwcShopModel * model = [self.dataAry[indexPath.section] listArr][indexPath.row];
    NSMutableArray * ary = [self.dataAry[indexPath.section] listArr];
    [ary removeObject:model];
    if (ary.count == 0) {
        [self.dataAry removeObjectAtIndex:indexPath.section];
        [self.baseTable reloadData];
    }else{
        [self.baseTable reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self GetTotalBill];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = [self.dataAry[indexPath.section] listArr][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击进入商品详情页面");

}



#pragma mark --- cell代理方法(cell 左侧按钮)
- (void)clickedWichLeftBtn:(UITableViewCell *)cell{
    NSIndexPath * indexpath = [self.baseTable indexPathForCell:cell];
    ShopCarModel * shopCarModel = self.dataAry[indexpath.section];//当前选中的商品对应的店铺的模型
    GwcShopModel * model = shopCarModel.listArr[indexpath.row];
    model.selected = !model.selected;
    NSInteger totalCount = 0;
    for (int i = 0; i < shopCarModel.listArr.count; i++) {
        GwcShopModel * GwcShopModel = shopCarModel.listArr[i];
        if (GwcShopModel.selected) {
            totalCount++;
        }
    }
    ShopCarModel * sectionModel = self.dataAry[indexpath.section];
    sectionModel.isChecked = (totalCount == shopCarModel.listArr.count);
    
    [self checkShopState];
}

//修改数量
- (void)changeTheShopCount:(UITableViewCell *)cell count:(NSInteger )count{
    NSIndexPath * indexpath = [self.baseTable indexPathForCell:cell];
    NSLog(@"%zd-----%zd", indexpath.section, indexpath.row);
    ShopCarModel * shopCarModel = self.dataAry[indexpath.section];//当前选中的商品对应的店铺的模型
    GwcShopModel * model = shopCarModel.listArr[indexpath.row];
    model.count = count;
    //    [self checkShopState];错误
    [self GetTotalBill];
}

#pragma mark --- CustomHeaderViewDelegate

- (void)clickedWhichHeaderView:(NSInteger)index{
    NSInteger sectionIndex = index - 2000;
    ShopCarModel * model = self.dataAry[sectionIndex];
    model.isChecked = !model.isChecked;
    NSMutableArray * tempAry = [self.dataAry[sectionIndex] listArr];
    for (int i = 0; i < tempAry.count; i++) {
        GwcShopModel * shopModel = tempAry[i];
        shopModel.selected = model.isChecked;
    }
    [self checkShopState];
}

#pragma mark --  BottomViewDelegate
-  (void)clickedBottomSelecteAll{//全选方法
    
    self.bottomModel.isSelecteAll = !self.bottomModel.isSelecteAll;
    for (int i = 0; i < self.dataAry.count; i++) {
        ShopCarModel * model = self.dataAry[i];
        model.isChecked = self.bottomModel.isSelecteAll;
        for (int j = 0; j < model.listArr.count; j++) {
            GwcShopModel *shopModel = model.listArr[j];
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
            NSLog(@"请选择要删除的商品");
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择要删除的商品";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }else{
            NSLog(@"选择了商品，进行删除");
            NSLog(@"要删除的数据模型是%@", _totalSelectedAry);
            [self warnMessage:@"是否确定要删除该商品"];
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

#pragma mark -- 公共方法
//选中商品或者选中店铺都会走这个公共方法。在这里判断选中的店铺数量还不是和数据源数组数量相等。一样的话就全选，否则相反。
- (void)checkShopState{
    NSInteger totalSelected = 0;
    for (int i = 0; i < self.dataAry.count; i++) {
        ShopCarModel * model = self.dataAry[i];
        if (model.isChecked) {
            totalSelected++;
        }
    }
    if (totalSelected == self.dataAry.count) {
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
    for (int i = 0; i < self.dataAry.count; i++) {
        ShopCarModel * model = self.dataAry[i];
        for (int j = 0; j < model.listArr.count; j++) {
            GwcShopModel *shopModel = model.listArr[j];
            if (shopModel.selected) {
                //保存model。如果是结算，传递选中商品，确认订单页面展示。如果是删除，根据此数组，拿到商品ID，用来删除。
                [_totalSelectedAry addObject:shopModel];
                [compentStr appendString:shopModel.shopTitle];
                totalMoney += shopModel.singlePrice * shopModel.count;
            }
        }
    }
    if (self.dataAry.count == 0) {
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

- (void)warnMessage:(NSString *)string{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //删除事件。多个删除直接重新请求数据！
    }
}



#pragma mark --- NavgationItemBtnClicked
- (void)editBtnClicked{
    self.isEditing = !self.isEditing;
    [self.rightTopBtn setTitle:self.isEditing ? @"完成" : @"编辑" forState:UIControlStateNormal];
    self.bottomModel.isEdit = self.isEditing;
    self.bottomView.model = self.bottomModel;
}

@end
