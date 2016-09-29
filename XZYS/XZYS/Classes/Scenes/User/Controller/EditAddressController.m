//
//  EditAddressController.m
//  XZYS
//
//  Created by 杨利 on 16/9/23.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "EditAddressController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "AddressModel.h"
#import "PCTModel.h"
#import "XZYS_Other.h"
#import <MBProgressHUD.h>

@interface EditAddressController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) AddressModel *model;
@property (nonatomic,strong) UIPickerView * pickerView;//自定义pickerview
@property (nonatomic,strong) NSMutableArray *provinceArrar;
@property (nonatomic,strong) NSMutableArray *cityArrar;
@property (nonatomic,strong) NSMutableArray *sectionArrar;
@property (nonatomic,copy) NSString *cityID;
@property (nonatomic,copy) NSString *provinceID;
@property (nonatomic,copy) NSString *sectionID;
@property (nonatomic,copy) NSString *cityIDtText;
@property (nonatomic,copy) NSString *provinceIDText;
@property (nonatomic,copy) NSString *sectionIDText;
@property (nonatomic,copy) NSString *btType;
@property (nonatomic , strong) UIView *back;
@property (nonatomic , strong) UIView *mainBack;
@end

@implementation EditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btType = @"0";
    NSLog(@"addressID:%@", self.addressID);
    self.title = @"编辑地址";
    self.addressLab.layer.borderWidth = 1;
    self.addressLab.layer.cornerRadius = 5;
    self.addressLab.layer.borderColor = XZYSRGBColor(231, 231, 231).CGColor;
    self.addressLab.layer.masksToBounds = YES;

    [self requestDataOne];
    //获取需要展示的数据
    [self getAddressInformation];
    [self setPickerView];
    self.mainBack.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)requestDataOne {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"address_id"] = self.addressID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Address/getAddressRow" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakSelf.model = [[AddressModel alloc] init];
        NSDictionary *dic = responseObject[@"data"];
        [weakSelf.model setValuesForKeysWithDictionary:dic];
        
        weakSelf.nameLab.text = weakSelf.model.consignee;
        weakSelf.numLab.text = weakSelf.model.contact_info;
        weakSelf.sectionCityLab.text = [NSString stringWithFormat:@"%@ %@ %@", weakSelf.model.area_province_text, weakSelf.model.area_city_text, weakSelf.model.area_district_text];
        weakSelf.addressLab.text = weakSelf.model.address;
        weakSelf.nameLab.text = weakSelf.model.consignee;
        weakSelf.nameLab.text = weakSelf.model.consignee;
        weakSelf.btType = weakSelf.model.is_default;
        if ([weakSelf.btType isEqualToString:@"1"]) {
            weakSelf.chooseImg.image = [UIImage imageNamed:@"gw_07"];
        } else if ([self.btType isEqualToString:@"0"]) {
            weakSelf.chooseImg.image = [UIImage imageNamed:@"gw_10"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (IBAction)provienceCityPicker:(id)sender {
    self.mainBack.hidden = NO;
}
- (IBAction)chooseAction:(id)sender {
    if ([self.btType isEqualToString:@"0"]) {
        self.chooseImg.image = [UIImage imageNamed:@"gw_07"];
        self.btType = @"1";
    } else if ([self.btType isEqualToString:@"1"]) {
        self.chooseImg.image = [UIImage imageNamed:@"gw_10"];
        self.btType = @"0";
    }
}

- (IBAction)saveBtnAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    params[@"address_id"] = weakSelf.addressID;
    params[@"consignee"] = weakSelf.nameLab.text;
    params[@"contact_info"] = weakSelf.numLab.text;
    params[@"area_province"] = weakSelf.provinceID;
    params[@"area_city"] = weakSelf.cityID;
    params[@"area_district"] = weakSelf.sectionID;
    params[@"address"] = weakSelf.addressLab.text;
    params[@"is_default"] = weakSelf.btType;
    
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Address/addressEdit" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([str isEqualToString:@"-1109"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)dateEnsureAction {
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", self.provinceID, self.cityID, self.sectionID];
    NSLog(@"%@", str);
    self.sectionCityLab.text = [NSString stringWithFormat:@"%@ %@ %@", self.provinceIDText, self.cityIDtText, self.sectionIDText];
    self.mainBack.hidden = YES;
}

- (void)dateCancleAction {
    self.mainBack.hidden = YES;
}


- (void)setPickerView {
    self.mainBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mainBack.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.7];
    [self.view addSubview:_mainBack];
    self.back = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 190, [UIScreen mainScreen].bounds.size.width, 190)];
    self.back.backgroundColor = [UIColor whiteColor];
    [self.mainBack addSubview:self.back];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    cancleBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancleBtn addTarget:self action:@selector(dateCancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.back addSubview:cancleBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
    [ensureBtn setTitle:@"确定" forState:0];
    ensureBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, 40);
    [ensureBtn addTarget:self action:@selector(dateEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.back addSubview:ensureBtn];
    
    // 初始化pickerView
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 150)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.back addSubview:self.pickerView];
    //指定数据源和委托
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)getAddressInformation {
    self.provinceArrar = [NSMutableArray array];
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaProvince" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *ar = responseObject[@"data"];
        for (NSDictionary *dic in ar) {
            PCTModel *model = [[PCTModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.provinceArrar addObject:model];
        }
        PCTModel *model = [[PCTModel alloc] init];
        model = self.provinceArrar[0];
        self.provinceID = model.area_id;
        [self requestCities];
        [self.pickerView reloadAllComponents];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

- (void)requestCities {
    self.cityArrar = [NSMutableArray array];
    [self.cityArrar removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"city_id"] = self.provinceID;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaCity/city_id/3" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *ar = responseObject[@"data"];
        for (NSDictionary *dic in ar) {
            PCTModel *model = [[PCTModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.cityArrar addObject:model];
        }
        PCTModel *model = [[PCTModel alloc] init];
        model = self.cityArrar[0];
        self.cityID = model.area_id;
        [self requestTowns];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView reloadComponent:1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

- (void)requestTowns {
    self.sectionArrar = [NSMutableArray array];
    [self.sectionArrar removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"district_id"] = self.cityID;
    [[AFHTTPSessionManager manager] GET:@"http://www.xiezhongyunshang.com/App/Area/getAreaDistrict/district_id/111" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *ar = responseObject[@"data"];
        for (NSDictionary *dic in ar) {
            PCTModel *model = [[PCTModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sectionArrar addObject:model];
        }
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        [self.pickerView reloadComponent:2];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.provinceArrar.count;//根据数组的元素个数返回几行数据
            break;
        case 1:
            result = self.cityArrar.count;
            break;
        case 2:
            result = self.sectionArrar.count;
            break;
        default:
            break;
    }
    return result;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title = nil;
    PCTModel *model1 = [[PCTModel alloc] init];
    PCTModel *model2 = [[PCTModel alloc] init];
    PCTModel *model3 = [[PCTModel alloc] init];
    switch (component) {
        case 0:
            model1 = self.provinceArrar[row];
            title = model1.area_name;
            self.provinceID = model1.area_id;
            self.provinceIDText = model1.area_name;
            break;
        case 1:
            model2 = self.cityArrar[row];
            title = model2.area_name;
            self.cityID = model2.area_id;
            self.cityIDtText = model2.area_name;
            break;
        case 2:
            model3 = self.sectionArrar[row];
            title = model3.area_name;
            self.sectionID = model3.area_id;
            self.sectionIDText = model3.area_name;
            break;
        default:
            break;
    }
    return title;
}

#pragma mark-设置下方的数据刷新
// 当选中了pickerView的某一行的时候调用
// 会将选中的列号和行号作为参数传入
// 只有通过手指选中某一行的时候才会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取对应列，对应行的数据
    //赋值
    if (0 == component) {
        PCTModel *model = [[PCTModel alloc] init];
        model = self.provinceArrar[row];
        self.provinceID = model.area_id;
        self.provinceIDText = model.area_name;
        [self requestCities];
    } else if (1 == component) {
        PCTModel *model = [[PCTModel alloc] init];
        model = self.cityArrar[row];
        self.cityID = model.area_id;
        self.cityIDtText = model.area_name;
        [self requestTowns];
    } else {
        PCTModel *model = [[PCTModel alloc] init];
        model = self.sectionArrar[row];
        self.sectionID = model.area_id;
        self.sectionIDText = model.area_name;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
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
