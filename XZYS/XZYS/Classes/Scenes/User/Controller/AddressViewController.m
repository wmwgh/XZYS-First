//
//  AddressViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/24.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "AddressViewController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "AddressTableViewCell.h"
#import "AppDelegate.h"
#import "AddressModel.h"
#import "XZYS_Other.h"
#import "EditAddressController.h"
#import <MBProgressHUD.h>
#import "AddNewAddressController.h"
#import "AddOrderViewController.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *mainTab;
@property (nonatomic , copy) NSString *btType;
@property (nonatomic , strong) UILabel *lab;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 240, SCREEN_WIDTH - 100, 20)];
    self.lab.text = @"请添加收货地址";
    [self.mainTab addSubview:_lab];
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.title = @"收货地址";
    self.mainTab.dataSource = self;
    self.mainTab.delegate = self;
    self.view.backgroundColor = XZYSRGBColor(234, 234, 234);
    self.mainTab.backgroundColor = XZYSRGBColor(234, 234, 234);
    self.mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([AddressTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(chooseBt:)
                                                 name:@"chooseBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editBt:)
                                                 name:@"editBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DeleBt:)
                                                 name:@"DeleBt"
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)chooseBt:(NSNotification *)text {
    NSString *str = text.userInfo[@"sid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"address_id"] = str;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Address/addressIsDefault" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = responseObject[@"msg"];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        [self resqusetData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


- (void)editBt:(NSNotification *)text {
    EditAddressController *xxVC = [[EditAddressController alloc] init];
    xxVC.addressID = text.userInfo[@"sid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)DeleBt:(NSNotification *)text {
    NSString *str = text.userInfo[@"sid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"address_id"] = str;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Address/addressDel" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self resqusetData];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = responseObject[@"msg"];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AddressModel *model = self.dataArray[indexPath.section];
    cell.nameLab.text = model.consignee;
    cell.numLab.text = model.contact_info;
    cell.editBt.tag = [model.ID intValue];
    cell.deleBt.tag = [model.ID intValue];
    cell.chooseBt.tag = [model.ID intValue];
    cell.addressLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@", model.area_province_text, model.area_city_text, model.area_district_text, model.address];
    if ([model.is_default isEqualToString:@"1"]) {
        cell.chooseImg.image = [UIImage imageNamed:@"gw_07"];
    } else if ([model.is_default isEqualToString:@"0"]) {
        cell.chooseImg.image = [UIImage imageNamed:@"gw_10"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainTab deselectRowAtIndexPath:indexPath animated:NO];
    AddressModel *model = [[AddressModel alloc] init];
    model = self.dataArray[indexPath.section];
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@ %@", model.area_province_text, model.area_city_text, model.area_district_text, model.address];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"4"] = model.ID;
    dic[@"1"] = model.consignee;
    dic[@"2"] = model.contact_info;
    dic[@"3"] = str;
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"传地址" object:self userInfo:[NSDictionary dictionaryWithObject:dic forKey:@"sid"]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 102;
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
                AddressModel *model = [[AddressModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
            self.lab.hidden = YES;
            [self.mainTab reloadData];
        } else {
            self.lab.hidden = NO;
            [self.mainTab reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (IBAction)addAddressAction:(UIButton *)sender {
    AddNewAddressController *addVC = [[AddNewAddressController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self resqusetData];
    
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
