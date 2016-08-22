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


@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) UserHeaderView *headerView;

@end

@implementation UserViewController

- (NSArray *)tableArray {
    if (!_tableArray) {
        _tableArray = [NSArray array];
    }
    return _tableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UserHeaderView *headerView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 114)];
    self.navigationController.navigationBarHidden = YES;
    self.tableArray = @[@"我的收藏", @"收货地址", @"调货", @"售后", @"系统消息", @"关于我们"];
    [self createTableView];
    UserHeaderView *headerView = [UserHeaderView loadFromNib];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 222);
    self.tableView.tableHeaderView = headerView;
    
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
//    switch (indexPath.row) {
//        case 0:
//            cell.titleImg.image = [UIImage imageNamed:@"552ce69611a93_64"];
//            break;
//        case 1:
//            cell.titleImg.image = [UIImage imageNamed:@"552ce810346b9_64"];
//            break;
//        case 2:
//            cell.titleImg.image = [UIImage imageNamed:@"552dc23c7d1ae_64"];
//            break;
//        case 3:
//            cell.titleImg.image = [UIImage imageNamed:@"552cdb1d559da_64"];
//            break;
//        default:
//            break;
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //进行跳转详细操作页面
//    if (indexPath.row == 0) {
//        self.hidesBottomBarWhenPushed = YES;
//        SearchViewController *vc = [[SearchViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
//    } else if (indexPath.row == 1) {
//        HotMovieController *hot = [[HotMovieController alloc] init];
//        [self.navigationController pushViewController:hot animated:YES];
//    } else if (indexPath.row == 2) {
//        self.hidesBottomBarWhenPushed = YES;
//        GameViewController *game = [[GameViewController alloc] init];
//        [self.navigationController pushViewController:game animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
//    }
//    else if (indexPath.row == 3) {
//        MusicListViewController *mlvc = [[MusicListViewController alloc] init];
//        [self.navigationController pushViewController:mlvc animated:YES];
//        
//    }
    
    
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
