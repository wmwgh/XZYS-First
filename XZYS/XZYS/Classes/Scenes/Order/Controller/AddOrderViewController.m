//
//  AddOrderViewController.m
//  XZYS
//
//  Created by 杨利 on 16/9/29.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "AddOrderViewController.h"
#import "AddressViewController.h"
#import "XZYS_Other.h"
#import "AddOrderViewCell.h"
#import "XIangQingViewController.h"
#import "ShopCarModel.h"
#import "ShopViewController.h"
#import "AppDelegate.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD.h>
#import "PayViewController.h"

static NSString *headerID = @"HeaderSID";
static NSString *footerID = @"FooterSID";

@interface AddOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic , strong) UIButton *titleButton;
@property (nonatomic , strong) UILabel *titLabel;
@property (nonatomic , strong) UITableViewHeaderFooterView *footerView;
@property (nonatomic , strong) UIView *footView;
@property (nonatomic , strong) UITextField *messageText;
@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , assign) float max;
@end

@implementation AddOrderViewController

- (NSMutableArray *)cellAllary {
    if (!_cellAllary) {
        _cellAllary = [NSMutableArray array];
    }
    return _cellAllary;
}

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewDidLoad {
    self.title = @"确认订单";
    self.resultLab.text = self.resultPrice;
    [super viewDidLoad];
    [self setCollection];
    for (int i = 0; i < self.cellAllary.count; i++) {
        NSString *str = @"";
        [self.array addObject:str];
    }
    [self resqusetData];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setAdd:)
                                                 name:@"传地址"
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)resqusetData {
    __weak typeof(self) weakSelf = self;
    weakSelf.dataArray = [NSMutableArray array];
    [weakSelf.dataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Address/getAddressAll" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id temp = responseObject[@"data"];
        if ([temp isKindOfClass:[NSArray class]]) {
            NSArray *arr = temp;
            for (NSDictionary *dic in arr) {
                if ([dic[@"is_default"] isEqualToString:@"1"]) {
                    self.nameLab.text = dic[@"consignee"];
                    self.phoneNumLab.text = dic[@"contact_info"];
                    self.addressLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@", dic[@"area_province_text"], dic[@"area_city_text"], dic[@"area_district_text"], dic[@"address"]];
                    self.resultID = dic[@"id"];
                }
            }
        } else {

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)setAdd:(NSNotification *)text {
    NSDictionary *dic = text.userInfo[@"sid"];
    self.nameLab.text = dic[@"1"];
    self.phoneNumLab.text = dic[@"2"];
    self.addressLab.text = dic[@"3"];
    self.resultID = dic[@"4"];
    
}

- (IBAction)tiJiao:(UIButton *)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:self.orderAllary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strjson1 = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:self.array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strjson2 = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    dic[@"uid"] = app.userIdTag;
    dic[@"cart_id"] = strjson1;
    dic[@"address_id"] = self.resultID;
    dic[@"remark"] = strjson2;
    if (dic[@"address_id"] != nil) {
        [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Order/orderAdd.html" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1.5];
            NSString *temp = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            if ([temp isEqualToString:@"-1300"]) {
#warning  tiao zhi fu
                NSString *jsonString = responseObject[@"data"];
                NSData *jData = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jData options:NSJSONReadingAllowFragments error:nil];
                NSArray *ary = jsonObject[@"order_ids"];
                PayViewController *payVC = [[PayViewController alloc] init];
                payVC.orderTyp = ary[0];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:payVC animated:YES];
                self.hidesBottomBarWhenPushed = YES;
                self.resultLab.text = @"0";
                self.cellAllary = nil;
                [self.mainTab reloadData];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}


- (void)endEdit:(UITextField *)sender {
    for (int i = 0; i < self.cellAllary.count; i++) {
        if (sender.tag == i) {
            [self.array replaceObjectAtIndex:i withObject:sender.text];
        }
    }
}

- (void)setCollection {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 128, SCREEN_WIDTH, SCREEN_HEIGHT - 173) style:UITableViewStyleGrouped];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    self.mainTab.backgroundColor = XZYSRGBColor(230, 230, 230);
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([AddOrderViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.mainTab];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellAllary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShopCarModel *model = [[ShopCarModel alloc] init];
    model = self.cellAllary[section];
    NSArray *ar = model.listArr;
    return ar.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCarModel *model1 = [[ShopCarModel alloc] init];
    model1 = self.cellAllary[indexPath.section];
    SonLislModel *model = [[SonLislModel alloc] init];
    model = model1.listArr[indexPath.row];
    AddOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XIangQingViewController *xxVC = [[XIangQingViewController alloc] init];
    ShopCarModel *model1 = [[ShopCarModel alloc] init];
    model1 = self.cellAllary[indexPath.section];
    SonLislModel *model = [[SonLislModel alloc] init];
    model = model1.listArr[indexPath.row];
    xxVC.passID = model.goods_id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
    [self.mainTab deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
    UIView *backView = [[UIView alloc] init];
    
    backView.backgroundColor = XZYSRGBColor(244, 241, 242);
    [headerView addSubview:backView];
    UIImageView *dpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 25, 25)];
    dpImage.image = [UIImage imageNamed:@"dp_sd"];
    [backView addSubview:dpImage];
    
    self.titLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 145, 40)];
    self.titLabel.font = [UIFont systemFontOfSize:14];
    [backView bringSubviewToFront:self.titLabel];
    [backView addSubview:self.titLabel];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(45, 0, SCREEN_WIDTH - 140, 40);
    [self.titleButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(titleSBT:) forControlEvents:UIControlEventTouchUpInside];
    self.titleButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [backView addSubview:self.titleButton];
    
    UIImageView *jianimage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titLabel.frame), 12, 15, 17)];
    jianimage.image = [UIImage imageNamed:@"dp_ht"];
    [backView addSubview:jianimage];
    
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    SonLislModel *model = [[SonLislModel alloc] init];
    model = self.cellAllary[section];
    self.titLabel.text = model.shop_name;
    self.titleButton.tag = [model.shop_id intValue];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ShopCarModel *model1 = [[ShopCarModel alloc] init];
    model1 = self.cellAllary[section];
    SonLislModel *model = [[SonLislModel alloc] init];
    NSArray *ar = model1.listArr;
    self.max = 0;
    for (model in ar) {
        float a = [model.price floatValue];
        int b = [model.num floatValue];
        self.max += a * b;
    }
    _footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    _footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerID];
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62)];
    UILabel *maiLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 42, 20)];
    maiLab.text = @"买家留言";
    maiLab.font = [UIFont systemFontOfSize:10];
    maiLab.textColor = XZYSPinkColor;
    [_footView addSubview:maiLab];
    self.messageText = [[UITextField alloc] init];
    self.messageText.font = [UIFont systemFontOfSize:10];
    self.messageText.frame = CGRectMake(55, 7, SCREEN_WIDTH - 60, 20);
    self.messageText.placeholder = @"选填，方便您与卖家达成一致";
    self.messageText.tag = section;
    self.messageText.textColor = [UIColor lightGrayColor];
    [self.messageText addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEnd];
    [_footView addSubview:self.messageText];
    UIView *underView = [[UIView alloc] initWithFrame:CGRectMake(5, 33, SCREEN_WIDTH - 10, 1)];
    underView.backgroundColor = XZYSRGBColor(234, 234, 234);
    [_footView addSubview:underView];
    
    UILabel *heji = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 38, 35, 20)];
    heji.text = @"合计:";
    heji.font = [UIFont systemFontOfSize:12];
    
    [_footView addSubview:heji];
    
    UILabel *pric = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 38, 90, 20)];
    pric.text = [NSString stringWithFormat:@"￥%.2f", self.max];
    pric.font = [UIFont systemFontOfSize:12];
    pric.textColor = XZYSPinkColor;
    [_footView addSubview:pric];
    _footView.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:_footView];
    return _footerView;
}
- (void)titleSBT:(UIButton *)sender {
    ShopViewController *shopVC = [[ShopViewController alloc] init];
    shopVC.shopID = [NSString stringWithFormat:@"%ld", sender.tag];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (IBAction)chooseAddress:(UIButton *)sender {
    AddressViewController *addADSVC = [[AddressViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addADSVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
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
