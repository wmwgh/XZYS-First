//
//  AllGucModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/31.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllGucModel : NSObject

/// 店铺名称
@property (nonatomic, copy)NSString * shop_name;

/// 商品尺码
@property (nonatomic, copy)NSString * goods_size;
/// 购物车ID
@property (nonatomic, copy)NSString * ID;
/// 用户ID
@property (nonatomic, copy)NSString * uid;
/// 商品ID
@property (nonatomic, copy)NSString * goods_id;
/// 店铺ID
@property (nonatomic, copy)NSString * shop_id;
/// 商品名称
@property (nonatomic, copy)NSString * goods_name;
/// 商品图片
@property (nonatomic, copy)NSString * goods_img;
/// 商品颜色
@property (nonatomic, copy)NSString * goods_color;
/// 商品单价
@property (nonatomic, copy)NSString * price;
/// 商品数量
@property (nonatomic, copy)NSString * num;
/// 购物车创建时间戳
@property (nonatomic, copy)NSString * create_time;
@end
