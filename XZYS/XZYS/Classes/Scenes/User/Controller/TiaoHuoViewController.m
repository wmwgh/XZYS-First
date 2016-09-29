//
//  TiaoHuoViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/24.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "TiaoHuoViewController.h"
#import "RootCell.h"
#import "ShowAllDoubleView.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import "TiaoHuoOrderCell.h"
#import <MBProgressHUD.h>
#import "TiaoHuoDetailController.h"

@interface TiaoHuoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic , strong) ShowAllDoubleView *rootView;
@property (nonatomic ,strong) NSMutableArray *allDataArray;


@end

@implementation TiaoHuoViewController

- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调货区";
    [self setTab];
    [self requestAllData];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callBack)
                                                 name:@"取消调货刷新UI"
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)callBack{
    [self requestAllData];
    NSLog(@"取消调货 get it");
}

- (void)setTab {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.mainTab registerNib:[UINib nibWithNibName:NSStringFromClass([TiaoHuoOrderCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTab.backgroundColor = [UIColor whiteColor];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    [self.view addSubview:self.mainTab];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SonLislModel *model = [[SonLislModel alloc] init];
    model = self.allDataArray[indexPath.section];
    TiaoHuoOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TiaoHuoDetailController *thVC = [[TiaoHuoDetailController alloc] init];
    SonLislModel *model = [[SonLislModel alloc] init];
    model = self.allDataArray[indexPath.row];
    thVC.orderID = model.ID;
    [self.mainTab deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:thVC animated:YES];
}


#pragma mark - 数据区
// 获取全部数据
- (void)requestAllData {
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _allDataArray = [NSMutableArray array];
    [_allDataArray removeAllObjects];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = appDelegate.userIdTag;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/DispatchGoods/dispatchGoodsList.html" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *order = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        if ([order isEqualToString:@"-101"]) {
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in dataArray) {
                SonLislModel *model = [[SonLislModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.allDataArray addObject:model];
            }
            [self.mainTab reloadData];
            // 隐藏指示器
            [SVProgressHUD dismiss];

        } else {
            UILabel *aview = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 50)];
            aview.text = @"暂无任何调货商品";
            aview.textAlignment = NSTextAlignmentCenter;
            [self.mainTab addSubview:aview];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = responseObject[@"msg"];
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            [self.mainTab reloadData];
            // 隐藏指示器
            [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
    }];
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
