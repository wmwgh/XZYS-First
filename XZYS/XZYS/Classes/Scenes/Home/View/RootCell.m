//
//  RootCell.m
//  UILesson15_UICollectionView
//
//  Created by 郭艳芳 on 16/4/27.
//  Copyright © 2016年 郭艳芳. All rights reserved.
//

#import "RootCell.h"
#import <UIImageView+WebCache.h>
#import "XZYS_URL.h"
#import "XZYS_Other.h"


@implementation RootCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 布局子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    
    
    UIView *aView = [[UIView alloc] initWithFrame:self.bounds];
    // 创建对象
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.width - 10)];
    self.photoImage.layer.cornerRadius = 3;
    self.photoImage.layer.masksToBounds = YES;
    self.tittleLable = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.photoImage.frame) + 3, CGRectGetWidth(self.frame) - 10, 36)];
    self.tittleLable.numberOfLines = 0;
    self.tittleLable.font = [UIFont systemFontOfSize:18];
    
    self.priceLable = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(self.tittleLable.frame) + 3, 80, 20)];
    self.priceLable.textAlignment = NSTextAlignmentLeft;
    self.priceLable.font = [UIFont systemFontOfSize:14];

    self.NumberLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 105, CGRectGetMaxY(self.tittleLable.frame) + 3, 90, 20)];
    self.NumberLable.textAlignment = NSTextAlignmentRight;
    self.NumberLable.font = [UIFont systemFontOfSize:14];

    [aView addSubview:self.photoImage];
    [aView addSubview:self.tittleLable];
    [aView addSubview:self.priceLable];
    [aView addSubview:self.NumberLable];
    
    [self.contentView addSubview:aView];
}

-(void)setOneModel:(SDFQModel *)oneModel{
    
    _oneModel = oneModel;
    NSString *str = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL,oneModel.goods_img];
    if (_oneModel.num == nil) {
        NSString *numStr = [NSString stringWithFormat:@"销量:%@件", _oneModel.sales_num];
        _NumberLable.text = numStr;
    } else if (_oneModel.sales_num == nil) {
        NSString *numStr = [NSString stringWithFormat:@"数量:%@件", _oneModel.num];
        _NumberLable.text = numStr;
    }
    NSString *priceStr = [NSString stringWithFormat:@"￥%@", _oneModel.price];
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:str]];
    _tittleLable.text = _oneModel.goods_name;
    _priceLable.text = priceStr;
    _priceLable.textColor = XZYSBlueColor;
    
    _NumberLable.textColor = XZYSPinkColor;
}

-(void)setTwoModel:(SPXQModel *)twoModel{
    
    _twoModel = twoModel;
    NSString *str = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL,_twoModel.goods_img];
    NSString *numStr = [NSString stringWithFormat:@"销量:%@件", _twoModel.sales_num];
    NSString *priceStr = [NSString stringWithFormat:@"￥%@", _twoModel.price];
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:str]];
    _tittleLable.text = _twoModel.goods_name;
    _priceLable.text = priceStr;
    _priceLable.textColor = XZYSBlueColor;
    _NumberLable.text = numStr;
    _NumberLable.textColor = XZYSPinkColor;
}


-(void)setShopModel:(ShopModel *)shopModel{
    
}

@end
