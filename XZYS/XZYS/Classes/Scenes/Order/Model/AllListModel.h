//
//  AllListModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/27.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllListModel : NSObject
// 订单ID
@property (nonatomic , copy) NSString *ID;
// 店铺ID
@property (nonatomic , copy) NSString *shop_id;
// 用户ID
@property (nonatomic , copy) NSString *uid;
// 订单编号
@property (nonatomic , copy) NSString *order_sn;
// 订单状态ID
@property (nonatomic , copy) NSString *order_status;
// 出货状态ID
@property (nonatomic , copy) NSString *shipping_status;
// 支付状态ID
@property (nonatomic , copy) NSString *pay_status;
// 出货周期
@property (nonatomic , copy) NSString *delivery_cycle;
// 收货人
@property (nonatomic , copy) NSString *consignee;
// 联系电话
@property (nonatomic , copy) NSString *telephone;
// 地区 - 省
@property (nonatomic , copy) NSString *province;
// 地区 - 市
@property (nonatomic , copy) NSString *city;
// 地区 - 县
@property (nonatomic , copy) NSString *county;
// 详细地址
@property (nonatomic , copy) NSString *area;
// 支付类型ID
@property (nonatomic , copy) NSString *payment;
// 订单金额
@property (nonatomic , copy) NSString *total_price;
// 创建时间
@property (nonatomic , copy) NSString *create_time;
// 支付时间
@property (nonatomic , copy) NSString *payment_time;
// 发货时间
@property (nonatomic , copy) NSString *shipping_time;
// 订单备注
@property (nonatomic , copy) NSString *remark;
// 店铺名称
@property (nonatomic , copy) NSString *shop_name;
// 订单状态（中文）
@property (nonatomic , copy) NSString *order_status_text;
// 订单商品列表
@property (nonatomic , copy) NSString *goods_list;
@end
