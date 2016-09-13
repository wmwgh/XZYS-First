//
//  UserViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "UserViewController.h"
#import "XZYS_URL.h"
#import "XZYS_Other.h"
#import "UserViewCell.h"
#import "UserHeaderView.h"
#import "UIView+LoadFromNib.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>

#import "CollectViewController.h"
#import "AddressViewController.h"
#import "TiaoHuoViewController.h"
#import "ShouHouViewController.h"
#import "XiTongViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "OrderListViewController.h"
#import "YiJianViewController.h"
#import "PassWordViewController.h"
#import "AppDelegate.h"

@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *tableArray;
@property (nonatomic , strong) UserHeaderView *headerView;
@property (nonatomic , strong) NSMutableArray *infoArray;
@property (nonatomic , strong) NSMutableDictionary *infoDic;
@property (nonatomic , copy) NSString *gongsijianjie;
@property (nonatomic , strong) NSMutableDictionary *params;
//@property (nonatomic ,strong) NSMutableArray *infoArray;

@end

@implementation UserViewController

- (NSArray *)tableArray {
    if (!_tableArray) {
        _tableArray = [NSArray array];
    }
    return _tableArray;
}

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

- (NSMutableDictionary *)infoDic {
    if (!_infoDic) {
        _infoDic = [NSMutableDictionary dictionary];
    }
    return _infoDic;
}
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人中心";
    self.navigationController.navigationBarHidden = YES;
    self.tableArray = @[@"我的收藏", @"收货地址", @"调货", @"售后", @"系统消息",  @"意见反馈", @"关于我们"];
    [self createTableView];
    self.headerView = [UserHeaderView loadFromNib];
    self.headerView.owner = self;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 222);
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.headerImg.layer.cornerRadius = 55 / 2;
    self.headerView.headerImg.layer.masksToBounds = YES;
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(callBack)
                                                 name: @"退出登录刷新UI"
                                               object: nil];
    
    // 按钮设置
//    [self setButton];
}

//- (void)setButton {
//    [self.headerView.changeInfo addTarget:self action:@selector(changeInfo:) forControlEvents:UIControlEventTouchUpInside];
//    self.headerView.changeInfo.userInteractionEnabled = YES;
//    [self.headerView.changePassWord addTarget:self action:@selector(changePassWord:) forControlEvents:UIControlEventTouchUpInside];
//    self.headerView.allListButton.userInteractionEnabled = YES;
//    [self.headerView.allListButton addTarget:self action:@selector(allListButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView.daiPayButton addTarget:self action:@selector(daiPayButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView.daiReceiveButton addTarget:self action:@selector(daiReceiveButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView.yiPayButton addTarget:self action:@selector(yiPayButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView.yiComplateButton addTarget:self action:@selector(yiComplateButton:) forControlEvents:UIControlEventTouchUpInside];
//}

//- (void)changeInfo:(UIButton *)sender {
//    NSLog(@"asdasdasd");
//    PassWordViewController *listVC = [[PassWordViewController alloc] init];
//    [self.navigationController pushViewController:listVC animated:YES];
//}
//- (void)changePassWord:(UIButton *)sender {
//    PassWordViewController *listVC = [[PassWordViewController alloc] init];
//    [self.navigationController pushViewController:listVC animated:YES];
//}
//- (void)allListButton:(UIButton *)sender {
//    OrderListViewController *listVC = [[OrderListViewController alloc] init];
//    [self.navigationController pushViewController:listVC animated:YES];
//}
//- (void)daiPayButton:(UIButton *)sender {
//    OrderListViewController *listVC = [[OrderListViewController alloc] init];
//    [self.navigationController pushViewController:listVC animated:YES];
//}
//- (void)daiReceiveButton:(UIButton *)sender {
//    OrderListViewController *listVC = [[OrderListViewController alloc] init];
//    [self.navigationController pushViewController:listVC animated:YES];
//}
//- (void)yiPayButton:(UIButton *)sender {
//    OrderListViewController *listVC = [[OrderListViewController alloc] init];
//    [self.navigationController pushViewController:listVC animated:YES];
//}
//- (void)yiComplateButton:(UIButton *)sender {
//    OrderListViewController *listVC = [[OrderListViewController alloc] init];
//    [self.navigationController pushViewController:listVC animated:YES];
//}

- (void)callBack{
     NSLog(@"get it");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resqusetInfoData];
}

- (void)setInfoMessage {
    ///////////
    [self.headerView.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _infoDic[@"member_picture"]]]];
    self.headerView.nameLabel.text = _infoDic[@"nickname"];
    self.headerView.jifen.text = [NSString stringWithFormat:@"积分：%@", _infoDic[@""]];
    [self.tableView reloadData];;
}


- (void)resqusetInfoData {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 默认的方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.params[@"uid"] = appDelegate.userIdTag;
    [manager POST:XZYS_Info_URL parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSError *error;
        NSString *result1 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        NSData *data = [result1 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        self.infoDic = dic[@"data"];
        [self setInfoMessage];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"UserViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       UserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //赋值:
    //Picture *model = _picArray[indexPath.row];
    //[cell.discorverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.titleLabel.text = self.tableArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.titleImg.image = [UIImage imageNamed:@"info_53"];
            break;
        case 1:
            cell.titleImg.image = [UIImage imageNamed:@"info_61"];
            break;
        case 2:
            cell.titleImg.image = [UIImage imageNamed:@"info_65"];
            break;
        case 3:
            cell.titleImg.image = [UIImage imageNamed:@"info_68"];
            break;
        case 4:
            cell.titleImg.image = [UIImage imageNamed:@"info_72"];
            break;
        case 5:
            cell.titleImg.image = [UIImage imageNamed:@"info_07"];
            break;
        case 6:
            cell.titleImg.image = [UIImage imageNamed:@"info_76"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

//section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 进行跳转详细操作页面
    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed = YES;
        CollectViewController *vc = [[CollectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.row == 1) {
        self.hidesBottomBarWhenPushed = YES;
        AddressViewController *hot = [[AddressViewController alloc] init];
        [self.navigationController pushViewController:hot animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.row == 2) {
        self.hidesBottomBarWhenPushed = YES;
        TiaoHuoViewController *game = [[TiaoHuoViewController alloc] init];
        [self.navigationController pushViewController:game animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.row == 3) {
        self.hidesBottomBarWhenPushed = YES;
        ShouHouViewController *mlvc = [[ShouHouViewController alloc] init];
        [self.navigationController pushViewController:mlvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.row == 4) {
        self.hidesBottomBarWhenPushed = YES;
        XiTongViewController *mlvc = [[XiTongViewController alloc] init];
        [self.navigationController pushViewController:mlvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.row == 5) {
        self.hidesBottomBarWhenPushed = YES;
        YiJianViewController *mlvc = [[YiJianViewController alloc] init];
        [self.navigationController pushViewController:mlvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.row == 6) {
        self.hidesBottomBarWhenPushed = YES;
        AboutViewController *mlvc = [[AboutViewController alloc] init];
        mlvc.str = self.gongsijianjie;
        [self.navigationController pushViewController:mlvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
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
