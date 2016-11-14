//
//  SPXQModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/17.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPXQModel : NSObject
/// 商品主图
@property (nonatomic, copy) NSString *goods_album;
/// 商品ID
@property (nonatomic, copy) NSString *goods_id;
/// 店铺ID
@property (nonatomic, copy) NSString *shop_id;
/// 商品名称
@property (nonatomic, copy) NSString *goods_name;
/// 商品简介
@property (nonatomic, copy) NSString *goods_desc;
/// 商品详情
@property (nonatomic, copy) NSString *goods_datails;
/// 商品类型
@property (nonatomic, copy) NSString *goods_type_id;
/// 商品价格
@property (nonatomic, copy) NSString *price;
/// 原始价格
@property (nonatomic, copy) NSString *ori_price;
/// 商品主图
@property (nonatomic, copy) NSString *goods_img;
/// 是否上架ID
@property (nonatomic, copy) NSString *is_on_sale;
/// 是否新品ID
@property (nonatomic, copy) NSString *is_new;
/// 是否热卖ID
@property (nonatomic, copy) NSString *is_hot;
/// 上架时间
@property (nonatomic, copy) NSString *create_time;
/// 更新时间
@property (nonatomic, copy) NSString *update_time;
/// 栏目ID
@property (nonatomic, copy) NSString *cate_id;
/// 商品编号
@property (nonatomic, copy) NSString *goods_sn;
/// 是否精品ID
@property (nonatomic, copy) NSString *is_boutique;
/// 销量
@property (nonatomic, copy) NSString *sales_num;
/// 排序
@property (nonatomic, copy) NSString *sort;
/// 所属模块ID
@property (nonatomic, copy) NSString *app_model_id;
/// 所属专场ID
@property (nonatomic, copy) NSString *app_space_id;
/// 鞋面材质
@property (nonatomic, copy) NSString *material;
/// 鞋底材质
@property (nonatomic, copy) NSString *solematerial;
/// 鞋头材质
@property (nonatomic, copy) NSString *topstyle;
/// 鞋里料材质
@property (nonatomic, copy) NSString *linmater;
/// 鞋跟材质
@property (nonatomic, copy) NSString *heel;
/// 鞋风格
@property (nonatomic, copy) NSString *style;
/// 鞋功能
@property (nonatomic, copy) NSString *function;
/// 鞋适合年龄
@property (nonatomic, copy) NSString *audience;
/// 鞋品牌
@property (nonatomic, copy) NSString *brand;
/// 尺寸
@property (nonatomic, copy) NSString *size;
/// 季节
@property (nonatomic, copy) NSString *season;
/// 颜色
@property (nonatomic, copy) NSString *color_remark;
@property (nonatomic, copy) NSString *material_remark;

@end
