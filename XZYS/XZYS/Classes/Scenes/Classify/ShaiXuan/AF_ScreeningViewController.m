//
//  AF_ScreeningViewController.m
//  差五个让步
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 Elephant. All rights reserved.
//

#import "AF_ScreeningViewController.h"

#import "AXPriceRangeCell.h"
#import "AF_BrandCell.h"

#define offset [UIScreen mainScreen].bounds.size.width - 50

@interface AF_ScreeningViewController () <UITableViewDataSource, UITableViewDelegate, AF_BrandCellDelegate>
{
    AXPriceRangeCell *priceRangeCell;
}
/** 重置按钮 */
@property (strong, nonatomic) UIButton * resetBut;
/** 确定按钮 */
@property (strong, nonatomic) UIButton * determineBut;
/** 展示tableView */
@property (strong, nonatomic) UITableView *tableV;
/** 选项标题数组 */
@property (strong, nonatomic) NSMutableArray *headerTitArr;
/** 选项数据数组 */
@property (strong, nonatomic) NSMutableArray *dataArr;
/** 是否展开状态数组 */
@property (strong, nonatomic) NSMutableArray *shrinkArr;
/** 是否选中状态字典 */
@property (strong, nonatomic) NSMutableDictionary *selectedDict;

@end

@implementation AF_ScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.headerTitArr = [NSMutableArray arrayWithObjects:@"价格区间(自定义)", @"专场", @"专区", @"材质", @"内里", @"鞋跟", @"季节", @"颜色", nil];
    
    self.dataArr = [NSMutableArray arrayWithObjects:@"女鞋",@"男鞋",@"童鞋",@"新品",@"爆款",@"调货",@"白色",@"红色",@"绿色",@"黑色",@"其他", nil];
    
    self.shrinkArr = [NSMutableArray array];
    self.selectedDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.headerTitArr.count; i++) {
        [self.shrinkArr addObject:@"NO"];
        NSMutableArray *selectedArr = [NSMutableArray array];
        for (int i = 0; i < self.dataArr.count; i++) {
            [selectedArr addObject:@"NO"];
        }
        [self.selectedDict setObject:selectedArr forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self.resetBut addTarget:self action:@selector(resetButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.determineBut addTarget:self action:@selector(determineButClick) forControlEvents:UIControlEventTouchUpInside];

    [self.tableV reloadData];
}

#pragma mark - 按钮点击事件
//重置
- (void)resetButClick{
    [self.shrinkArr removeAllObjects];
    [self.selectedDict removeAllObjects];
    for (int i = 0; i < self.headerTitArr.count; i++) {
        [self.shrinkArr addObject:@"NO"];
        NSMutableArray *selectedArr = [NSMutableArray array];
        for (int i = 0; i < self.dataArr.count; i++) {
            [selectedArr addObject:@"NO"];
        }
        [self.selectedDict setObject:selectedArr forKey:[NSString stringWithFormat:@"%d", i]];
    }
    [self.tableV reloadData];
}
//确定
- (void)determineButClick{
    
    NSMutableArray *strArr = [NSMutableArray array];//
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *priceStr = [NSString stringWithFormat:@"%@-%@", priceRangeCell.priceText1.text, priceRangeCell.priceText2.text];
//    [dict setObject:priceStr forKey:self.headerTitArr[0]];
    
    [strArr addObject:priceStr];//
    
    for (int i = 1; i < self.headerTitArr.count; i++) {
        
        NSString *sectionStr = [NSString stringWithFormat:@"%d", i];
        NSMutableArray *sectionArr = self.selectedDict[sectionStr];
        
        NSMutableArray *lineArr = [NSMutableArray array];
        
        for (int i = 0; i < sectionArr.count; i++) {
            if ([sectionArr[i] isEqualToString:@"YES"]) {
                [lineArr addObject:[NSString stringWithFormat:@"%@", self.dataArr[i]]];
                
                [strArr addObject:self.dataArr[i]];
            }
        }
//        if (lineArr.count > 0) {
//            
//            [dict setObject:lineArr forKey:self.headerTitArr[i]];
//            
//        }
    }
    NSLog(@"筛选条件 : \n%@", [self dictionaryToJson:strArr]);
//    NSLog(@"筛选条件 : \n%@", strArr);
}
/** 字典转json字符串 */
- (NSString*)dictionaryToJson:(id)data
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** 改变选项收缩状态 */
- (void)shrinkButClick:(UIButton *)button
{
    
    if ([self.shrinkArr[button.tag] isEqualToString:@"NO"]) {
        NSLog(@"点击了第%ld块,展开", button.tag);
        [self.shrinkArr replaceObjectAtIndex:button.tag withObject:@"YES"];
    }else {
        NSLog(@"点击了第%ld块,收缩", button.tag);
        [self.shrinkArr replaceObjectAtIndex:button.tag withObject:@"NO"];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:button.tag];
    [self.tableV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -

#pragma mark - AF_BrandCellDelegate
/** 取得选中选项的值，改变选项状态，刷新列表 */
- (void)selectedValueChangeBlock:(NSInteger)section key:(NSInteger)index value:(NSString *)value
{
    
    NSString *sectionStr = [NSString stringWithFormat:@"%ld", section];
    NSMutableArray *arr = self.selectedDict[sectionStr];
    [arr replaceObjectAtIndex:index withObject:value];
    [self.selectedDict setObject:arr forKey:sectionStr];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [self.tableV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -

#pragma mark - tableView UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerTitArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        AF_BrandCell *cell = [[AF_BrandCell alloc]init];
        cell.isShrinkage = self.shrinkArr[indexPath.section];
        cell.attributeArr = self.dataArr;
        return cell.height;
    }
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, offset, 40)];
    
    UILabel *titLab = [[UILabel alloc]init];
    titLab.text = self.headerTitArr[section];
    titLab.font = [UIFont systemFontOfSize:14.0];
    CGSize titSize = [titLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    titLab.textColor = XZYSBlueColor;
    titLab.frame = CGRectMake(5, 0, titSize.width, 40);
    [myView addSubview:titLab];
    
    if (section > 0) {
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(offset - 27, 9, 20, 22)];
        UIButton *shrinkBut = [[UIButton alloc]initWithFrame:CGRectMake(offset - 70, 0, 50, 40)];
        shrinkBut.tag = section;
        [shrinkBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        shrinkBut.titleLabel.font = [UIFont systemFontOfSize:13];
        if ([self.shrinkArr[section] isEqualToString:@"NO"]) {
            [shrinkBut setTitle:@"全部" forState:UIControlStateNormal];
            img1.image = [UIImage imageNamed:@"sx_xjtb"];
        }else {
            [shrinkBut setTitle:@"收起" forState:UIControlStateNormal];
            img1.image = [UIImage imageNamed:@"sx_sjta"];

        }
        [shrinkBut addTarget:self action:@selector(shrinkButClick:) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:img1];
        [myView addSubview:shrinkBut];
    }
    
    return myView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"priceRangeCell";
        priceRangeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!priceRangeCell) {
            priceRangeCell = [[[NSBundle mainBundle] loadNibNamed:@"AXPriceRangeCell" owner:nil options:nil]lastObject];
            priceRangeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return priceRangeCell;
    }else {
        AF_BrandCell *cell = [AF_BrandCell cellWithTableView:tableView dataArr:self.dataArr indexPath:indexPath];
        /** 取消cell点击状态 */
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.tag = indexPath.section;
        cell.delegate = self;
        
        NSString *sectionStr = [NSString stringWithFormat:@"%ld", indexPath.section];
        cell.selectedArr = self.selectedDict[sectionStr];
        
        cell.isShrinkage = self.shrinkArr[indexPath.section];
        
        cell.attributeArr = self.dataArr;
        
        return cell;
    }
}

#pragma mark -

#pragma mark - 懒加载
-(UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.width, [UIScreen mainScreen].bounds.size.height - 69) style:UITableViewStyleGrouped];
        _tableV.backgroundColor = [UIColor whiteColor];
        /** 隐藏cell分割线 */
        [_tableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self.view addSubview:_tableV];
    }
    return _tableV;
}

- (UIButton *)resetBut//重置
{
    if (!_resetBut) {
        _resetBut = [[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, self.width/2, 49)];
        [_resetBut setBackgroundColor:[UIColor whiteColor]];
        [_resetBut setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_resetBut setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.view addSubview:_resetBut];
    }
    return _resetBut;
}
- (UIButton *)determineBut//确定
{
    if (!_determineBut) {
        _determineBut = [[UIButton alloc]initWithFrame:CGRectMake(self.width/2, [UIScreen mainScreen].bounds.size.height - 49, self.width/2, 49)];
        [_determineBut setBackgroundColor:XZYSBlueColor];
        [_determineBut setTitle:@"确定" forState:UIControlStateNormal];
        [_determineBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineBut setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.view addSubview:_determineBut];
    }
    return _determineBut;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
