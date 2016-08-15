//
//  SDFQModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/9.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDFQModel : NSObject
/// 专区名称
@property (nonatomic, strong) NSString *name;
/// 专区描述
@property (nonatomic, strong) NSString *subtitle;
/// 商品名称
@property (nonatomic, strong) NSString *goods_name;
/// 商品图片
@property (nonatomic, strong) NSString *goods_img;
/// 商品价格
@property (nonatomic, strong) NSString *price;
/// 商品销量
@property (nonatomic, strong) NSString *sales_num;


@end
