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

@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *tableArray;
@property (nonatomic , strong) UserHeaderView *headerView;
@property (nonatomic , strong) NSMutableArray *infoArray;
@property (nonatomic , strong) NSMutableDictionary *infoDic;
@property (nonatomic , copy) NSString *gongsijianjie;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人中心";
    self.navigationController.navigationBarHidden = YES;
    self.tableArray = @[@"我的收藏", @"收货地址", @"调货", @"售后", @"系统消息", @"关于我们"];
    [self createTableView];
    [self setInfoMessage];
    [self resqusetInfoData];
}

- (void)setInfoMessage {
    UserHeaderView *headerView = [UserHeaderView loadFromNib];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 222);
    self.tableView.tableHeaderView = headerView;
    headerView.headerImg.layer.cornerRadius = 55 / 2;
    headerView.headerImg.layer.masksToBounds = YES;
    ///////////
    headerView.nameLabel.text = @"大王叫我来巡山";
    headerView.headerImg.image = [UIImage imageNamed:@"head.jpg"];
//    headerView.nameLabel.text = _infoDic[@"nickname"];
//    NSString *str = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _infoDic[@"member_picture"]];
//    [headerView.headerImg sd_setImageWithURL:[NSURL URLWithString:str]];
}

- (void)resqusetInfoData {
    [[AFHTTPSessionManager manager] GET:XZYS_Info_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    [[AFHTTPSessionManager manager] GET:XZYS_GSJJ_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.infoDic = responseObject[@"data"];
        self.gongsijianjie = responseObject[@"data"];
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
//        ShouHouViewController *mlvc = [[ShouHouViewController alloc] init];
        
        LoginViewController *mlvc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:mlvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.row == 4) {
        self.hidesBottomBarWhenPushed = YES;
        XiTongViewController *mlvc = [[XiTongViewController alloc] init];
        [self.navigationController pushViewController:mlvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.row == 5) {
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
