//
//  CollectModel.h
//  XZYS
//
//  Created by 杨利 on 16/9/18.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject
// 订单ID
@property (nonatomic , copy) NSString *ID;
// 店铺ID
@property (nonatomic , copy) NSString *shop_name;
// 用户ID
@property (nonatomic , copy) NSString *shop_logo;
// 订单编号
@property (nonatomic , copy) NSString *sales_num;
// 订单状态ID
@property (nonatomic , copy) NSString *goods_num;
// 出货状态ID
@property (nonatomic , copy) NSString *collect_num;
// 支付状态ID
@property (nonatomic , copy) NSString *goods_id;
// 出货周期
@property (nonatomic , copy) NSString *goods_img;
// 收货人
@property (nonatomic , copy) NSString *goods_name;
// 联系电话
@property (nonatomic , copy) NSString *price;
@property (nonatomic , copy) NSString *goods_list;
@end
