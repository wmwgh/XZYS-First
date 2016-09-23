//
//  XIangQingViewController.m
//  XZYS
//
//  Created by 杨利 on 16/8/16.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "XIangQingViewController.h"
#import "Goods.h"
#import "XZYS_Other.h"
#import "UIView+LoadFromNib.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import "XZYS_URL.h"
#import "SPXQModel.h"
#import <SVProgressHUD.h>
#import "LFLUISegmentedControl.h"
#import "GoodsTableViewCell.h"
#import "DetailView.h"
#import "GuiGeView.h"
#import "ShoppingCarViewController.h"
#import <UIImageView+WebCache.h>
#import "FzhScrollViewAndPageView.h"
#import "ShopViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <MBProgressHUD.h>
#import "AddGoodsToTabViewCell.h"
#import "ColorSizePickView.h"
#import "RootPickSizeCell.h"
#import "RootPickColorCell.h"
#import "PickerViewHeaderView.h"
#import "AddOutTableViewCell.h"

#define btWidth (SCREEN_WIDTH - SCREEN_WIDTH / 3) / 4
@interface XIangQingViewController ()<FzhScrollViewDelegate,LFLUISegmentedControlDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) NSMutableDictionary *dict;
@property (nonatomic , strong) UIScrollView *backView;
/// 商品详情数组
@property (nonatomic, strong) NSMutableArray *SPXQArray;
/// 商品详情图片数组
@property (nonatomic, strong) NSMutableArray *SpxqPicArray;
/// 商品详情颜色数组
@property (nonatomic, strong) NSMutableArray *SpxqColorArray;
@property (nonatomic, strong) NSMutableArray *SpxqColorKeyArray;
/// 商品详情尺寸数组
@property (nonatomic, strong) NSMutableArray *SpxqSizeArray;
@property (nonatomic, strong) NSMutableArray *SpxqSizeKeyArray;
@property (nonatomic , strong) UIView *alineView;
/// 商品详情季节数组
@property (nonatomic, strong) NSMutableArray *SpxqSeasonArray;
@property (nonatomic , strong) UITableView *mainTable;
@property (nonatomic , strong) UIScrollView *backScr;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) NSArray *LFLarray;
@property (nonatomic , strong) UIButton *dianpuBT;
@property (nonatomic , strong) UIButton *shoucangBT;
@property (nonatomic , strong) UIButton *gouwucheBT;
@property (nonatomic , strong) UIView *pickerBackView;
@property (nonatomic , strong) UIView *underView;
@property (nonatomic , strong) UITableView *chooseTab;
@property (nonatomic , strong) UITextField *numText;
@property (nonatomic , assign) NSInteger underNum;
@property (nonatomic , strong) NSMutableArray *sizeColorNum;
@property (nonatomic , strong) NSMutableArray *sizeColorNumChn;
@property (nonatomic , strong) NSMutableArray *sizeColorNumOut;
@property (nonatomic , strong) NSMutableArray *sizeColorNumOutChn;
@property (nonatomic , strong) NSMutableArray *colrorBtArray;
@property (nonatomic , strong) NSMutableArray *sizeBtArray;
@property (nonatomic , strong) NSMutableArray *dictArray;
@property (nonatomic , strong) UIButton *pickButton;
@property (nonatomic , strong) UILabel *picklabel;
@property (nonatomic , strong) UIView *blineView;
@property (nonatomic , strong) UIImageView *imagea;
@property (nonatomic , strong) UIView *clineView;
@property (nonatomic , strong) UIView *dlineView;
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , copy) NSString *colorStr;
@property (nonatomic , copy) NSString *sizeStr;
@property (nonatomic , copy) NSString *colorStrChn;
@property (nonatomic , copy) NSString *sizeStrChn;
@property (nonatomic , strong) ColorSizePickView *rootPickView;
@property (nonatomic, strong) UIScrollView *mainScrollView; /**< 正文mainSV */
@property (nonatomic ,strong) LFLUISegmentedControl * LFLuisement; /**< LFLuisement */
@property (nonatomic, strong) SPXQModel *GuiGeModel;
@property (nonatomic ,strong) GoodsTableViewCell *goodsScroll;
@property (nonatomic, strong) FzhScrollViewAndPageView *fzhView;
@property (nonatomic , strong) UICollectionView *colorCollectionView;
@end

@implementation XIangQingViewController
static NSString *const pickColor_cell = @"pickColor_cell";
static NSString *const pickSize_cell = @"pickSize_cell";
- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (NSMutableArray *)colrorBtArray {
    if (!_colrorBtArray) {
        _colrorBtArray = [NSMutableArray array];
    }
    return _colrorBtArray;
}
- (NSMutableArray *)sizeBtArray {
    if (!_sizeBtArray) {
        _sizeBtArray = [NSMutableArray array];
    }
    return _sizeBtArray;
}
- (NSMutableArray *)sizeColorNum {
    if (!_sizeColorNum) {
        _sizeColorNum = [NSMutableArray array];
    }
    return _sizeColorNum;
}

- (NSMutableArray *)dictArray {
    if (!_dictArray) {
        _dictArray = [NSMutableArray array];
    }
    return _dictArray;
}
- (NSMutableArray *)sizeColorNumChn {
    if (!_sizeColorNumChn) {
        _sizeColorNumChn = [NSMutableArray array];
    }
    return _sizeColorNumChn;
}

- (NSMutableArray *)sizeColorNumOut {
    if (!_sizeColorNumOut) {
        _sizeColorNumOut = [NSMutableArray array];
    }
    return _sizeColorNumOut;
}
- (NSMutableArray *)sizeColorNumOutChn {
    if (!_sizeColorNumOutChn) {
        _sizeColorNumOutChn = [NSMutableArray array];
    }
    return _sizeColorNumOutChn;
}

- (NSMutableArray *)SpxqPicArray {
    if (!_SpxqPicArray) {
        _SpxqPicArray = [NSMutableArray array];
    }
    return _SpxqPicArray;
}

- (NSMutableArray *)SPXQArray {
    if (!_SPXQArray) {
        _SPXQArray = [NSMutableArray array];
    }
    return _SPXQArray;
}

- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载数据......"];
    _cellHeight = 5;
    self.LFLarray = [NSArray array];
    // 请求数据
    [self requestData];
    // 详情按钮
    [self initXQView];
    // 导航
    [self initLayoutSegmt];
    // 主scrollView
    [self createMainScrollView];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sizeCallBack:)
                                                 name:@"sizeBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(colorCallBack:)
                                                 name:@"colorBt"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleCallBack:)
                                                 name:@"deleBt"
                                               object:nil];
}
- (void)deleCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue];
    [self.sizeColorNumChn removeObjectAtIndex:tagID];
    [self.sizeColorNum removeObjectAtIndex:tagID];
    [self.chooseTab reloadData];
}
- (void)sizeCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.sizeStr = self.SpxqSizeKeyArray[tagID];
    self.sizeStrChn = self.SpxqSizeArray[tagID];
    for (UIButton *bt in self.sizeBtArray) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}
- (void)colorCallBack:(NSNotification *)text {
    NSInteger tagID = [text.userInfo[@"sid"] integerValue] - 1000;
    self.colorStr = self.SpxqColorKeyArray[tagID];
    self.colorStrChn = self.SpxqColorArray[tagID];
    for (UIButton *bt in self.colrorBtArray) {
        if (bt.tag - 1000 == tagID) {
            [bt setTitleColor:XZYSBlueColor forState:UIControlStateNormal];
            [bt setBackgroundColor:[UIColor whiteColor]];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = XZYSBlueColor.CGColor;
        } else if (bt.tag != tagID) {
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.layer.borderWidth = 0;
            bt.backgroundColor = XZYSRGBColor(234, 234, 234);
        }
    }
}

- (void)minAction:(UIButton *)sender {
    int a = [self.numText.text intValue];
    int b = a - 1;
    if (b == 0) {
        b = 1;
    }
    self.numText.text = [NSString stringWithFormat:@"%d", b];
    
}
- (void)plusAction:(UIButton *)sender {
    int a = [self.numText.text intValue];
    int b = a + 1;
    self.numText.text = [NSString stringWithFormat:@"%d", b];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.chooseTab]) {
        return self.sizeColorNum.count;
    }
    
    else if ([tableView isEqual:self.mainTable])
    {
        return self.sizeColorNumOut.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.chooseTab]) {
        AddGoodsToTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        if (self.sizeColorNumChn.count != 0) {
            NSArray *temp = self.sizeColorNumChn[indexPath.row];
            cell.titltLab.text = [NSString stringWithFormat:@"颜色:%@      尺码:%@      X%@", temp[0], temp[1], temp[2]];
            cell.titltLab.font = [UIFont systemFontOfSize:14];
            cell.titltLab.textColor = XZYSBlueColor;
            cell.deleBtn.tag = indexPath.row;
            return cell;
        }
    }
    
    else if ([tableView isEqual:self.mainTable])
    {
        AddOutTableViewCell *cellout = [tableView dequeueReusableCellWithIdentifier:@"cellout" forIndexPath:indexPath];
        cellout.backgroundColor = [UIColor whiteColor];
        if (self.sizeColorNumChn.count != 0) {
            NSArray *temp = self.sizeColorNumChn[indexPath.row];
            cellout.titltLab.text = [NSString stringWithFormat:@"颜色:%@      尺码:%@      X%@", temp[0], temp[1], temp[2]];
            cellout.titltLab.font = [UIFont systemFontOfSize:14];
            cellout.titltLab.textColor = XZYSBlueColor;
            return cellout;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainTable deselectRowAtIndexPath:indexPath animated:NO];
    [self.chooseTab deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return SCREEN_WIDTH + 256 + _cellHeight;
    return 25;
}

- (void)addGoodsToCell {
    NSMutableArray *arr = [NSMutableArray array];
    if ((self.colorStr != nil || self.colorStr != NULL) && (self.sizeStr != nil || self.sizeStr != NULL)) {
        [arr addObject:self.colorStr];
        [arr addObject:self.sizeStr];
        [arr addObject:self.numText.text];
        [self.sizeColorNum addObject:arr];
    }
    NSMutableArray *arr1 = [NSMutableArray array];
    if ((self.colorStrChn != nil || self.colorStrChn != NULL) && (self.sizeStrChn != nil || self.sizeStrChn != NULL)) {
        [arr1 addObject:self.colorStrChn];
        [arr1 addObject:self.sizeStrChn];
        [arr1 addObject:self.numText.text];
        [self.sizeColorNumChn addObject:arr1];
    }
    [self.chooseTab reloadData];
}
- (void)addGoods {
    [self.dictArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *aood = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = aood.userIdTag;
    params[@"goods_id"] = self.passID;
    params[@"shop_id"] = _dict[@"shop_id"];
    for (int i = 0; i < self.sizeColorNum.count; i++) {
        NSArray *ar = self.sizeColorNum[i];
        NSMutableDictionary *clDic = [NSMutableDictionary dictionary];
        [clDic setObject:ar[0] forKey:@"color_id"];
        [clDic setObject:ar[1] forKey:@"size_id"];
        [clDic setObject:ar[2] forKey:@"num"];
        [self.dictArray addObject:clDic];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strjson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"cart_list"] = strjson;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/cartAdd" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = responseObject[@"msg"];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide= YES;
        [hud hide:YES afterDelay:1.5];
        [self.sizeColorNumChn removeAllObjects];
        [self.sizeColorNum removeAllObjects];
        [self.chooseTab reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)addGoodsOut {
    [self.dictArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *aood = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = aood.userIdTag;
    params[@"goods_id"] = self.passID;
    params[@"shop_id"] = _dict[@"shop_id"];
    for (int i = 0; i < self.sizeColorNumOut.count; i++) {
        NSArray *ar = self.sizeColorNumOut[i];
        NSMutableDictionary *clDic = [NSMutableDictionary dictionary];
        [clDic setObject:ar[0] forKey:@"color_id"];
        [clDic setObject:ar[1] forKey:@"size_id"];
        [clDic setObject:ar[2] forKey:@"num"];
        [self.dictArray addObject:clDic];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strjson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"cart_list"] = strjson;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/cartAdd" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = responseObject[@"msg"];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide= YES;
        [hud hide:YES afterDelay:1.5];
        [self.sizeColorNumOutChn removeAllObjects];
        [self.sizeColorNumOut removeAllObjects];
        [self.sizeColorNumChn removeAllObjects];
        [self.sizeColorNum removeAllObjects];
        [self.chooseTab reloadData];
        [self.mainTable reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    self.backScr.contentSize = CGSizeMake(SCREEN_WIDTH , SCREEN_WIDTH + 250);
    self.mainTable.frame = CGRectMake(0, CGRectGetMaxY(self.alineView.frame), SCREEN_WIDTH, 5);
    self.blineView.frame =CGRectMake(5, CGRectGetMaxY(self.mainTable.frame), SCREEN_WIDTH - 10, 1);
    self.picklabel.frame = CGRectMake(20, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH - 70, 40);
    self.pickButton.frame = CGRectMake(20, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH - 70, 40);
    self.imagea.frame = CGRectMake(SCREEN_WIDTH - 33, CGRectGetMaxY(self.blineView.frame) + 11, 15, 20);
    self.imageView.frame = CGRectMake(0, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH, 40);
    self.clineView.frame = CGRectMake(5, CGRectGetMaxY(self.imageView.frame) + 1, SCREEN_WIDTH - 10, 1);
    self.dlineView.frame = CGRectMake(5, CGRectGetMaxY(self.dlineView.frame) + 5, SCREEN_WIDTH - 10, 1);
}

- (void)pickAction:(UIButton *)sender {
    [self.view addSubview:self.underView];
    self.pickerBackView.frame = CGRectMake(70, 0, SCREEN_WIDTH - 70, self.underNum + 230);
    [self.underView addSubview:self.pickerBackView];
}

- (void)backBTAction {
    _cellHeight = 5;
    self.pickerBackView.frame = CGRectMake(SCREEN_WIDTH + 15, 0, SCREEN_WIDTH - 70, SCREEN_HEIGHT - 70);
    [self.sizeColorNumOut setArray:self.sizeColorNum];
    [self.sizeColorNumOutChn setArray:self.sizeColorNumChn];
    [self.underView removeFromSuperview];
    
    if (self.sizeColorNumOut.count != 0) {
        _cellHeight = 100;
    }
    self.backScr.contentSize = CGSizeMake(SCREEN_WIDTH , SCREEN_WIDTH + _cellHeight + 250);
    self.mainTable.frame = CGRectMake(0, CGRectGetMaxY(self.alineView.frame), SCREEN_WIDTH, _cellHeight);
    self.blineView.frame =CGRectMake(5, CGRectGetMaxY(self.mainTable.frame), SCREEN_WIDTH - 10, 1);
    self.picklabel.frame = CGRectMake(20, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH - 70, 40);
    self.pickButton.frame = CGRectMake(20, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH - 70, 40);
    self.imagea.frame = CGRectMake(SCREEN_WIDTH - 33, CGRectGetMaxY(self.blineView.frame) + 11, 15, 20);
    self.imageView.frame = CGRectMake(0, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH, 40);
    self.clineView.frame = CGRectMake(5, CGRectGetMaxY(self.imageView.frame) + 1, SCREEN_WIDTH - 10, 1);
    self.dlineView.frame = CGRectMake(5, CGRectGetMaxY(self.dlineView.frame) + 5, SCREEN_WIDTH - 10, 1);
    
    [self.mainTable reloadData];
}

#pragma mark -------- 颜色尺寸
- (void)setPickerBackView {
    self.underView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.underView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.7];
    UIButton *backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBT addTarget:self action:@selector(backBTAction) forControlEvents:UIControlEventTouchUpInside];
    backBT.frame = self.view.bounds;
    backBT.backgroundColor = [UIColor clearColor];
    [self.underView addSubview:backBT];
    self.pickerBackView = [[UIView alloc] init];
    self.pickerBackView.alpha = 1;
    self.pickerBackView.frame = CGRectMake(SCREEN_WIDTH + 15, 0, SCREEN_WIDTH - 70, SCREEN_HEIGHT - 70);
    self.pickerBackView.backgroundColor = [UIColor whiteColor];
    
    int height = 0;
    if (_SpxqColorArray.count < 4) {
        height = 70;
    } else if (_SpxqColorArray.count < 7) {
        height = 105;
    } else if (_SpxqColorArray.count < 10) {
        height = 140;
    } else if (_SpxqColorArray.count < 13) {
        height = 175;
    } else if (_SpxqColorArray.count < 15) {
        height = 210;
    } else if (_SpxqColorArray.count < 18) {
        height = 245;
    }
    if (_SpxqSizeArray.count < 4) {
        height += 70;
    } else if (_SpxqSizeArray.count < 7) {
        height += 105;
    } else if (_SpxqSizeArray.count < 10) {
        height += 140;
    } else if (_SpxqSizeArray.count < 13) {
        height += 175;
    } else if (_SpxqSizeArray.count < 15) {
        height += 210;
    } else if (_SpxqSizeArray.count < 18) {
        height += 245;
    }
    self.rootPickView = [[ColorSizePickView alloc] initWithFrame:self.view.bounds];
    [self.pickerBackView addSubview:self.rootPickView];
    // 创建对象并指定样式
    self.colorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.pickerBackView.frame.size.width, height) collectionViewLayout:self.rootPickView.myFlowLayout];
    self.colorCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.pickerBackView addSubview:self.colorCollectionView];
    // 设置代理
    self.colorCollectionView.dataSource = self;
    self.colorCollectionView.delegate = self;
    
    // 第一步：注册cell
    [self.colorCollectionView registerNib:[UINib nibWithNibName:@"RootPickColorCell" bundle:nil] forCellWithReuseIdentifier:pickColor_cell];
    [self.colorCollectionView registerNib:[UINib nibWithNibName:@"RootPickSizeCell" bundle:nil] forCellWithReuseIdentifier:pickSize_cell];
    
    //   注册头视图
    [self.colorCollectionView registerClass:[PickerViewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"picker"];
    
    UILabel *numLb = [[UILabel alloc] initWithFrame: CGRectMake(5, CGRectGetMaxY(self.colorCollectionView.frame) + 6, 200, 20)];
    numLb.text = @"数量";
    numLb.textColor = XZYSPinkColor;
    numLb.font = [UIFont systemFontOfSize:15];
    [self.pickerBackView addSubview:numLb];
    
    UIButton *minBt = [UIButton buttonWithType:UIButtonTypeCustom];
    minBt.frame = CGRectMake(40, CGRectGetMaxY(numLb.frame) + 8, 32, 25);
    [minBt setImage:[UIImage imageNamed:@"shopCar_cut"] forState:UIControlStateNormal];
    [minBt addTarget:self action:@selector(minAction:) forControlEvents:UIControlEventTouchUpInside];
    minBt.backgroundColor = XZYSRGBColor(234, 234, 234);
    [self.pickerBackView addSubview:minBt];
    UIButton *plusBt = [UIButton buttonWithType:UIButtonTypeCustom];
    plusBt.frame = CGRectMake(120, CGRectGetMaxY(numLb.frame) + 8, 32, 25);
    [plusBt setImage:[UIImage imageNamed:@"shopCar_plus"] forState:UIControlStateNormal];
    [plusBt addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    plusBt.backgroundColor = XZYSRGBColor(234, 234, 234);
    [self.pickerBackView addSubview:plusBt];
    
    self.numText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(minBt.frame) + 3, CGRectGetMinY(minBt.frame) + 1, 42, 23)];
    self.numText.backgroundColor = [UIColor whiteColor];
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(minBt.frame) + 2, CGRectGetMinY(minBt.frame), 44, 25)];
    a.backgroundColor = XZYSRGBColor(234, 234, 234);
    [self.pickerBackView addSubview:a];
    self.numText.textAlignment = NSTextAlignmentCenter;
    self.numText.font = [UIFont systemFontOfSize:15];
    self.numText.text = @"1";
    [self.pickerBackView addSubview:self.numText];
    
    self.chooseTab = [[UITableView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(minBt.frame) + 10, SCREEN_WIDTH - 80, 170) style:UITableViewStylePlain];
    self.chooseTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chooseTab.layer.cornerRadius = 5;
    self.chooseTab.backgroundColor = XZYSRGBColor(234, 234, 234);
    self.chooseTab.delegate = self;
    self.chooseTab.dataSource = self;
    [self.chooseTab registerNib:[UINib nibWithNibName:NSStringFromClass([AddGoodsToTabViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    //设置代理
    self.backScr.delegate = self;
    [self.pickerBackView addSubview:self.chooseTab];
    
    UIButton *carBT = [UIButton buttonWithType:UIButtonTypeCustom];
    carBT.titleLabel.font = [UIFont systemFontOfSize:14];
    carBT.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 3 - 75, CGRectGetMaxY(self.chooseTab.frame) + 10, SCREEN_WIDTH / 3, 44);
    [carBT setTitle:@"加入购物车" forState:UIControlStateNormal];
    [carBT addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
    carBT.backgroundColor = XZYSBlueColor;
    [self.pickerBackView addSubview:carBT];
    self.underNum = self.chooseTab.frame.origin.y;
    
    UIButton *addBT = [UIButton buttonWithType:UIButtonTypeCustom];
    addBT.titleLabel.font = [UIFont systemFontOfSize:14];
    addBT.frame = CGRectMake(5, CGRectGetMaxY(self.chooseTab.frame) + 10, SCREEN_WIDTH / 3, 44);
    [addBT setTitle:@"添加商品" forState:UIControlStateNormal];
    [addBT addTarget:self action:@selector(addGoodsToCell) forControlEvents:UIControlEventTouchUpInside];
    addBT.backgroundColor = XZYSPinkColor;
    [self.pickerBackView addSubview:addBT];
    
}

#pragma mark UICollectionViewDataSource Method----

// 设置多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// 设置每个分区里面有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.SpxqColorArray.count;
    } else if (section == 1) {
        return self.SpxqSizeArray.count;
    }
    return 0;
}

// 返回每一个item的cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 第二步：重用cell
    if (indexPath.section == 0) {
        RootPickColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pickColor_cell forIndexPath:indexPath];
        NSString *str = _SpxqColorArray[indexPath.row];
        [cell.colorBtn setTitle:str forState:UIControlStateNormal];
        cell.colorBtn.tag = indexPath.row + 1000;
        [self.colrorBtArray addObject:cell.colorBtn];
        return cell;
    } else if (indexPath.section == 1){
        RootPickSizeCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:pickSize_cell forIndexPath:indexPath];
        NSString *str1 = _SpxqSizeArray[indexPath.row];
        [cell1.sizePickBt setTitle:str1 forState:UIControlStateNormal];
        cell1.sizePickBt.tag = indexPath.row + 1000;
        [self.sizeBtArray addObject:cell1.sizePickBt];
        return cell1;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
}

// 返回头视图和尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    PickerViewHeaderView *firstHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"picker" forIndexPath:indexPath];
    NSArray *ar = @[@"颜色", @"尺寸"];
    firstHeaderView.headerLabel.text = ar[indexPath.section];
    firstHeaderView.headerLabel.font = [UIFont systemFontOfSize:15];
    firstHeaderView.headerLabel.textColor = XZYSPinkColor;
    return firstHeaderView;
}


- (void)initLayoutSegmt {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //    1.初次创建：
    LFLUISegmentedControl* LFLuisement=[[LFLUISegmentedControl alloc]initWithFrame:CGRectMake(90, 20, SCREEN_WIDTH - 180, 44)];
    LFLuisement.delegate = self;
    //   2.设置显示切换标题数组
    self.LFLarray = [NSArray arrayWithObjects:@"商 品",@"详 情",@"规 格",nil];
    [LFLuisement AddSegumentArray:self.LFLarray];
    //   default Select the Button
    [LFLuisement selectTheSegument:0];
    self.LFLuisement = LFLuisement;
    [self.view addSubview:LFLuisement];
    
    UIButton *backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(17, 32, 13, 20);
    [backBT setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBT];
    
}
//SCREEN_WIDTH + 64 + 7 + 40 + 80;
- (void)createTableView {
    self.backScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backScr.bounces = NO;
    self.backScr.pagingEnabled = NO;
    self.backScr.showsVerticalScrollIndicator = NO;
    self.backScr.showsHorizontalScrollIndicator = NO;
    self.backScr.contentSize = CGSizeMake(SCREEN_WIDTH , SCREEN_WIDTH + 250);
    //设置代理
    self.backScr.delegate = self;
    [self LBTView];
    [self addThreeView];
    [self.mainScrollView addSubview:self.backScr];
    
}

- (void)addThreeView {
    SPXQModel *model = self.SPXQArray[0];
    DetailView *detailView = [DetailView loadFromNib];
    detailView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    detailView.xiangqingLabel.text = model.goods_datails;
    [self.mainScrollView addSubview:detailView];
    
    GuiGeView *guigeView = [GuiGeView loadFromNib];
    guigeView.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    NSString *sizeString = [NSString string];
    for (NSString *sizeStr in self.SpxqSizeArray) {
        sizeString = [sizeString stringByAppendingString:[NSString stringWithFormat:@"%@ ", sizeStr]];
    }
    NSString *colorString = [NSString string];
    for (NSString *colorStr in self.SpxqColorArray) {
        colorString = [colorString stringByAppendingString:[NSString stringWithFormat:@"%@ ", colorStr]];
    }
    guigeView.yanse.text = colorString;
    guigeView.chicun.text = sizeString;
    guigeView.xiemiancailiao.text = model.material;
    guigeView.xiegenleixing.text = model.heel;
    guigeView.gongneng.text = model.function;
    guigeView.fengge.text = model.style;
    guigeView.xietoukuanshi.text = model.topstyle;
    guigeView.xiedicaizhi.text = model.solematerial;
    guigeView.xielicaizhi.text = model.linmater;
    guigeView.shiYong.text = model.audience;
    [self.mainScrollView addSubview:guigeView];
}

#pragma mark --- 轮播图
- (void)LBTView {
    //创建view（view中包含UIScrollView、UIPageControl，设置frame）
    _fzhView = [[FzhScrollViewAndPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *str in self.SpxqPicArray) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, str];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        [tempArray addObject:imageView];
    }
    //把imageView数组存到fzhView里
    [_fzhView setImageViewAry:tempArray];
    //开启自动翻页
    [_fzhView shouldAutoShow:YES];
    //遵守协议
    _fzhView.delegate = self;
    //把图片展示的view加到当前页面
    [self.backScr addSubview:_fzhView];
#pragma mark - 商品信息
    SPXQModel *model = self.SPXQArray[0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_fzhView.frame) + 3, SCREEN_WIDTH - 10, 35)];
    titleLabel.text = model.goods_name;
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backScr addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame) + 3, 80, 20)];
    priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    priceLabel.textColor = XZYSBlueColor;
    priceLabel.font = [UIFont systemFontOfSize:16];
    [self.backScr addSubview:priceLabel];
    
    UILabel *zheluLab = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(titleLabel.frame) + 3, SCREEN_WIDTH - 95, 20)];
    zheluLab.textColor = XZYSPinkColor;
//    zheluLab.text = [NSString stringWithFormat:@"注:%@", model.goods_desc];
    zheluLab.text = @"注:男鞋8双起批,女鞋5双起批";
    zheluLab.font = [UIFont systemFontOfSize:11];
    zheluLab.textAlignment = NSTextAlignmentRight;
    [self.backScr addSubview:zheluLab];

    UILabel *beforePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(priceLabel.frame) + 3, 80, 18)];
    beforePriceLabel.text = [NSString stringWithFormat:@"价格￥%@", model.ori_price];
    beforePriceLabel.textColor = XZYSRGBColor(232, 184, 66);
    beforePriceLabel.font = [UIFont systemFontOfSize:12];
    [self.backScr addSubview:beforePriceLabel];
    
    UIView *elineView = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(beforePriceLabel.frame) + 9, 46, 1)];
    elineView.backgroundColor = XZYSRGBColor(232, 184, 66);
    [self.backScr addSubview:elineView];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(priceLabel.frame) + 3, SCREEN_WIDTH - 95, 18)];
    
    numLabel.textColor = XZYSPinkColor;
    numLabel.text = [NSString stringWithFormat:@"销量:%@件", model.sales_num];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.font = [UIFont systemFontOfSize:11];
    [self.backScr addSubview:numLabel];
    
    self.alineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(beforePriceLabel.frame) + 3, SCREEN_WIDTH - 10, 1)];
    self.alineView.backgroundColor = XZYSLightDarkColor;
    [self.backScr addSubview:self.alineView];
    
    
#pragma mark -------mainTab
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.alineView.frame), SCREEN_WIDTH, _cellHeight)];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass([AddOutTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cellout"];
    self.mainTable.backgroundColor = [UIColor whiteColor];
    [self.backScr addSubview:self.mainTable];
    
    self.blineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.mainTable.frame), SCREEN_WIDTH - 10, 1)];
    self.blineView.backgroundColor = XZYSLightDarkColor;
    [self.backScr addSubview:self.blineView];
    self.picklabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH - 70, 40)];
    self.picklabel.text = @"选择   颜色   尺码";
    self.picklabel.font = [UIFont systemFontOfSize:15];
    [self.backScr addSubview:self.picklabel];
    
    self.pickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pickButton.frame = CGRectMake(20, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH - 70, 40);
    [self.pickButton addTarget:self action:@selector(pickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backScr addSubview:self.pickButton];
    
    self.imagea = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 33, CGRectGetMaxY(self.blineView.frame) + 11, 15, 20)];
    self.imagea.image = [UIImage imageNamed:@"bz_22"];
    [self.backScr addSubview:self.imagea];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.blineView.frame), SCREEN_WIDTH, 40)];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.backScr bringSubviewToFront:self.imageView];
    [self.backScr addSubview:self.imageView];
    
    self.clineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imageView.frame) + 1, SCREEN_WIDTH - 10, 1)];
    self.clineView.backgroundColor = XZYSLightDarkColor;
    [self.backScr addSubview:self.clineView];
    
    self.dlineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.dlineView.frame) + 5, SCREEN_WIDTH - 10, 1)];
    self.dlineView.backgroundColor = XZYSLightDarkColor;
    [self.backScr addSubview:self.dlineView];
    // 隐藏指示器
    [SVProgressHUD dismiss];
}


#pragma mark --- 协议里面方法，点击某一页
-(void)didClickPage:(FzhScrollViewAndPageView *)view atIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld页",index);
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;
    [weakSelf.SpxqPicArray removeAllObjects];
    weakSelf.SpxqSizeArray = [NSMutableArray array];
    [weakSelf.SpxqSizeArray removeAllObjects];
    weakSelf.SpxqColorArray = [NSMutableArray array];
    [weakSelf.SpxqColorArray removeAllObjects];
    
    weakSelf.SpxqSizeKeyArray = [NSMutableArray array];
    [weakSelf.SpxqSizeKeyArray removeAllObjects];
    weakSelf.SpxqColorKeyArray = [NSMutableArray array];
    [weakSelf.SpxqColorKeyArray removeAllObjects];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_SPXQ_URL, weakSelf.passID];
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        _dict = responseObject[@"data"];
        NSDictionary *sizeDic = _dict[@"size"];
        NSDictionary *colorDic = _dict[@"color_remark"];
        weakSelf.SpxqPicArray = _dict[@"goods_img_list"];
        NSMutableArray *arry = [NSMutableArray arrayWithArray:[sizeDic allKeys]];
        NSMutableArray *arry1 = [NSMutableArray arrayWithArray:[colorDic allKeys]];
        NSInteger count = [arry count];
        NSInteger count1 = [arry1 count];
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                if([[arry objectAtIndex:j] compare:[arry objectAtIndex:j + 1] options:NSNumericSearch] == 1){                      [arry exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        for (int i = 0; i < count1; i++) {
            for (int j = 0; j < count1 - i - 1; j++) {
                if([[arry objectAtIndex:j] compare:[arry1 objectAtIndex:j + 1] options:NSNumericSearch] == 1){                      [arry1 exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
        weakSelf.SpxqColorKeyArray = arry1;
        weakSelf.SpxqSizeKeyArray = arry;
        for (NSString *ck in weakSelf.SpxqColorKeyArray) {
            [weakSelf.SpxqColorArray addObject:colorDic[ck]];
        }
        for (NSString *sk in weakSelf.SpxqSizeKeyArray) {
            [weakSelf.SpxqSizeArray addObject:sizeDic[sk]];
        }
        
        weakSelf.GuiGeModel = [[SPXQModel alloc] init];
        [weakSelf.GuiGeModel setValuesForKeysWithDictionary:_dict];
        [weakSelf.SPXQArray addObject:weakSelf.GuiGeModel];
        [self createTableView];
        [self setPickerBackView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        // 显示加载错误信息
        [SVProgressHUD showErrorWithStatus:@"网络异常，加载失败！"];
        NSLog(@"%@", error);
    }];
}

//创建正文ScrollView内容
- (void)createMainScrollView {
    CGFloat begainScrollViewY = 49 + 64;
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,(SCREEN_HEIGHT - begainScrollViewY))];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.bounces = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, (SCREEN_HEIGHT - begainScrollViewY));
    //设置代理
    self.mainScrollView.delegate = self;
}

#pragma mark --- UIScrollView代理方法

static NSInteger pageNumber = 0;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageNumber = (int)(scrollView.contentOffset.x / SCREEN_WIDTH + 0.5);
//    滑动SV里视图,切换标题
    [self.LFLuisement selectTheSegument:pageNumber];
}

#pragma mark ---LFLUISegmentedControlDelegate
/**
 *  点击标题按钮
 *
 *  @param selection 对应下标 begain 0
 */
-(void)uisegumentSelectionChange:(NSInteger)selection{
    //    加入动画,显得不太过于生硬切换
    [UIView animateWithDuration:.2 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH *selection, 0)];
    }];
}

- (void)initXQView {
    UIView *bBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
    UIButton *carBT = [UIButton buttonWithType:UIButtonTypeCustom];
    carBT.titleLabel.font = [UIFont systemFontOfSize:14];
    carBT.frame = CGRectMake(SCREEN_WIDTH*2 / 3 + 10, 0, SCREEN_WIDTH / 3, 49);
    [carBT setTitle:@"加入购物车" forState:UIControlStateNormal];
    [carBT addTarget:self action:@selector(addGoodsOut) forControlEvents:UIControlEventTouchUpInside];
    carBT.backgroundColor = XZYSBlueColor;
    [bBackView addSubview:carBT];
    
    UIButton *kefuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    kefuBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [kefuBT setImage:[UIImage imageNamed:@"kf"] forState:UIControlStateNormal];
    kefuBT.frame = CGRectMake(0, 8, btWidth, 40);
    [kefuBT addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    [bBackView addSubview:kefuBT];
    
    self.shoucangBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shoucangBT.titleLabel.font = [UIFont systemFontOfSize:14];
    self.shoucangBT.frame = CGRectMake(btWidth, 8, btWidth, 40);
    [self.shoucangBT addTarget:self action:@selector(shoucangAction:) forControlEvents:UIControlEventTouchUpInside];
    [bBackView addSubview:self.shoucangBT];
    
    self.dianpuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dianpuBT.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dianpuBT.frame = CGRectMake(btWidth * 2, 8, btWidth, 40);
    [self.dianpuBT setImage:[UIImage imageNamed:@"dp"] forState:UIControlStateNormal];
    [self.dianpuBT addTarget:self action:@selector(dianpuClick:) forControlEvents:UIControlEventTouchUpInside];
    [bBackView addSubview:self.dianpuBT];
    
    self.gouwucheBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gouwucheBT.titleLabel.font = [UIFont systemFontOfSize:14];
    self.gouwucheBT.frame = CGRectMake(btWidth * 3, 8, btWidth, 40);
    [self.gouwucheBT setImage:[UIImage imageNamed:@"gwc"] forState:UIControlStateNormal];
    [self.gouwucheBT addTarget:self action:@selector(gouwuche:) forControlEvents:UIControlEventTouchUpInside];
    [bBackView addSubview:self.gouwucheBT];
    [self.view addSubview:bBackView];
    [self.view addSubview:self.backView];
}

- (void)gwcBadmeg {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *aood = [[UIApplication sharedApplication] delegate];
    params[@"uid"] = aood.userIdTag;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Cart/getCartNum" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *numstr = responseObject[@"data"];
        int num = [numstr intValue];
#warning badgeValue ++++++++++++++++++++
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)yanzheng {
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appd.userIdTag;
    params[@"goods_id"] = self.passID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/checkCollectGoods" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSDictionary *dic = responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        if([result isEqualToString:@"-902"]){
        [self.shoucangBT setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
        } else {
        [self.shoucangBT setImage:[UIImage imageNamed:@"sc_dp"] forState:UIControlStateNormal];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//  收藏
- (void)shoucangAction:(UIButton *)esnder {
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = appd.userIdTag;
    params[@"goods_id"] = self.passID;
    [[AFHTTPSessionManager manager] POST:@"http://www.xiezhongyunshang.com/App/Collect/collectGoods" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据加载完后回调.
        NSDictionary *dic = responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if([result isEqualToString:@"-900"]){
            hud.labelText = dic[@"msg"];
            [self.shoucangBT setImage:[UIImage imageNamed:@"sc_dp"] forState:UIControlStateNormal];
        } else {
            hud.labelText = dic[@"msg"];
            [self.shoucangBT setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
        }
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide= YES;
        [hud hide:YES afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
//  店铺
- (void)dianpuClick:(UIButton *)sender {
    ShopViewController *dianpuVC = [[ShopViewController alloc] init];
    dianpuVC.shopID = _dict[@"shop_id"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dianpuVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}
//  购物车
- (void)gouwuche:(UIButton *)dender {
    ShoppingCarViewController *carVC = [[ShoppingCarViewController alloc] init];
    self.tabBarController.selectedIndex = 2;
    self.hidesBottomBarWhenPushed = NO;
    [self.tabBarController.navigationController pushViewController:carVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
// 客服
- (void)kefuClick {
}

- (void)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self yanzheng];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sizeBt" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"colorBt" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleBt" object:nil];
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
