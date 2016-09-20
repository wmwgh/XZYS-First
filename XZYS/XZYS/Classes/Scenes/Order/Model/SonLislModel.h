//
//  SonLislModel.h
//  XZYS
//
//  Created by 杨利 on 16/9/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SonLislModel : NSObject
// 订单商品ID
@property (nonatomic , copy) NSString *ID;
// 商品ID
@property (nonatomic , copy) NSString *goods_id;
// 商品名称
@property (nonatomic , copy) NSString *goods_name;
// 商品图片
@property (nonatomic , copy) NSString *goods_img;
@property (nonatomic , copy) NSString *shop_name;
@property (nonatomic , copy) NSString *shop_id;
// 商品颜色
@property (nonatomic , copy) NSString *goods_color;
// 商品尺码
@property (nonatomic , copy) NSString *goods_size;
// 购买数量
@property (nonatomic , copy) NSString *num;
// 商品价格
@property (nonatomic , copy) NSString *price;
// 商品小计
@property (nonatomic , copy) NSString *goods_subtotal;
@end
