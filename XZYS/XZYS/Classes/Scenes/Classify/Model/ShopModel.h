//
//  ShopModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/29.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
/// 店铺ID
@property (nonatomic, copy) NSString *ID;
/// 店主姓名
@property (nonatomic, copy) NSString *nickname;
/// 联系电话
@property (nonatomic, copy) NSString *mobile;
/// 地区 - 省
@property (nonatomic, copy) NSString *provincial;
/// 地区 - 市
@property (nonatomic, copy) NSString *city;
/// 地区 - 县
@property (nonatomic, copy) NSString *district;
/// 详细地址
@property (nonatomic, copy) NSString *address;
/// 座机电话
@property (nonatomic, copy) NSString *telephone;
/// 微信号码
@property (nonatomic, copy) NSString *wechat;
/// 店铺LOGO
@property (nonatomic, copy) NSString *shop_logo;
/// 店铺名称
@property (nonatomic, copy) NSString *shop_name;
/// 店铺简介
@property (nonatomic, copy) NSString *shop_brief_introduction;
/// 店铺详细介绍
@property (nonatomic, copy) NSString *shop_introduction;
/// 商品数量
@property (nonatomic, copy) NSString *goods_num;
/// 销量
@property (nonatomic, copy) NSString *sales_num;
/// 收藏数量
@property (nonatomic, copy) NSString *collect_num;



@end
