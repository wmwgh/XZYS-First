//
//  SDFQModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/9.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDFQModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *goods_id;
/// 商店ID
@property (nonatomic , copy) NSString *shop_id;
/// 专区名称
@property (nonatomic, copy) NSString *name;
/// 专区描述
@property (nonatomic, copy) NSString *subtitle;
/// 商品名称
@property (nonatomic, copy) NSString *goods_name;
/// 商品图片
@property (nonatomic, copy) NSString *goods_img;
/// 商品价格
@property (nonatomic, copy) NSString *price;
/// 商品销量
@property (nonatomic, copy) NSString *sales_num;
@property (nonatomic, copy) NSString *goods_album;


@end
