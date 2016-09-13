//
//  TiaoHuoDetailModel.h
//  XZYS
//
//  Created by 杨利 on 16/9/13.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiaoHuoDetailModel : NSObject
// 订单ID
@property (nonatomic , copy) NSString *ID;
// 创建时间
@property (nonatomic , copy) NSString *create_time;
// 更新时间
@property (nonatomic , copy) NSString *update_time;
// 商品名称
@property (nonatomic , copy) NSString *goods_name;
// 商品图片
@property (nonatomic , copy) NSString *goods_img;
// 商品尺码
@property (nonatomic , copy) NSString *goods_size;
// 商品颜色
@property (nonatomic , copy) NSString *goods_color;
// 收货人
@property (nonatomic , copy) NSString *contact_name;
// 联系电话
@property (nonatomic , copy) NSString *contact_mobile;
// 店铺ID
@property (nonatomic , copy) NSString *shop_id;
// 用户ID
@property (nonatomic , copy) NSString *uid;
// 店铺地址
@property (nonatomic , copy) NSString *address;
// 店铺名称
@property (nonatomic , copy) NSString *shop_name;
// 调货数量
@property (nonatomic , copy) NSString *num;
// 订单商品ID
@property (nonatomic , copy) NSString *order_goods_id;
// 调货金额
@property (nonatomic , copy) NSString *price;
// 订单编号
@property (nonatomic , copy) NSString *order_sn;

@end
