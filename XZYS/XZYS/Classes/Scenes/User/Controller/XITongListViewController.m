//
//  XITongListViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "XITongListViewController.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "XiTongModel.h"
#import "XZYS_Other.h"
#import "XITongListCell.h"

@interface XITongListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *xiTongArray;
@property (nonatomic , strong) UITableView *mainTableView;

@end

@implementation XITongListViewController

- (NSMutableArray *)xiTongArray {
    if (!_xiTongArray) {
        _xiTongArray = [NSMutableArray array];
    }
    return _xiTongArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _model.title;
    NSLog(@"%@", _model.ID);
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
    
    [self requestData];
    [self createTableView];
}

#pragma mark -- TableView
- (void)createTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mainTableView.bounces = NO;
    self.mainTableView.separatorStyle = NO;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    //注册cell
    [self.mainTableView registerNib:[UINib nibWithNibName:@"XITongListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.xiTongArray.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XITongListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    XiTongModel *model = [[XiTongModel alloc] init];
//    model = self.xiTongArray[indexPath.row];
    
    cell.cellPic.image = [UIImage imageNamed:@"head.jpg"];
    cell.titleLabel.text = @"腾讯新闻,事实派";
    cell.decLabel.text = @"腾讯新闻,事实派。新闻中心,包含有时政新闻、国内新闻、国际新闻、社会新闻、时事评论、新闻图片、新闻专题、新闻论坛、军事、历史、的专业时事报道门户网站";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 330;
}

//section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainTableView deselectRowAtIndexPath:indexPath animated:NO];
    // 跳转到 筛选页面？？？？？？？？？？
//    XITongListViewController *listVC = [[XITongListViewController alloc] init];
//    listVC.model = self.xiTongArray[indexPath.row];
//    [self.navigationController pushViewController:listVC animated:YES
//     ];
}

- (void)requestData {
    [[AFHTTPSessionManager manager] GET:XZYS_XXTS_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        XiTongModel *model = [[XiTongModel alloc] init];
        [model setValuesForKeysWithDictionary:dic[@"1"]];
        [self.xiTongArray addObject:model];
        XiTongModel *model1 = [[XiTongModel alloc] init];
        [model1 setValuesForKeysWithDictionary:dic[@"2"]];
        [self.xiTongArray addObject:model1];
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
