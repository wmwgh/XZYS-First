//
//  Goods.m
//  XZYS
//
//  Created by 杨利 on 16/8/16.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "Goods.h"
#import "XZYS_Other.h"

@implementation Goods

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _goodsView = [[UITableView alloc] initWithFrame:self.frame];
        [self addSubview:_goodsView];
        
        [self LBTView];
    }
    return self;
}

#pragma mark --- 轮播图
- (void)LBTView {
    // 创建view（view中包含UIScrollView、UIPageControl，设置frame）
    _lbtView = [[FzhScrollViewAndPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    // 把n张图片放到imageView上
    _picArray = [NSMutableArray array];

    for (int i = 0; i < _picArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        //        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",i]];
//        LBTModel *model = [[LBTModel alloc] init];
//        model = self.LBTArray[i];
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, model.img];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        [_picArray addObject:imageView];
    }
    
    // 把imageView数组存到fzhView里
    [_lbtView setImageViewAry:_picArray];
    // 开启自动翻页
    [_lbtView shouldAutoShow:YES];
    // 遵守协议
    _lbtView.delegate = self;
    // 把图片展示的view加到当前页面
    [self addSubview:_lbtView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
