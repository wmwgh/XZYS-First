//
//  AddressModel.h
//  XZYS
//
//  Created by 杨利 on 16/9/23.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
/// 收货地址ID
@property (nonatomic, copy) NSString *ID;
/// 用户ID
@property (nonatomic, copy) NSString *uid;
/// 是否是默认地址
@property (nonatomic, copy) NSString *is_default;
/// 创建时间
@property (nonatomic, copy) NSString *create_time;
/// 收货人
@property (nonatomic, copy) NSString *consignee;
/// 联系资料
@property (nonatomic, copy) NSString *contact_info;
/// 地区 - 省
@property (nonatomic, copy) NSString *area_province;
/// 详细地址
@property (nonatomic, copy) NSString *address;
/// 地区 - 市
@property (nonatomic, copy) NSString *area_city;
/// 地区 - 县
@property (nonatomic, copy) NSString *area_district;
/// 更新时间
@property (nonatomic, copy) NSString *update_time;
/// 地区 - 省（中文）
@property (nonatomic, copy) NSString *area_province_text;
/// 地区 - 市（中文）
@property (nonatomic, copy) NSString *area_city_text;
/// 地区 - 县（中文）
@property (nonatomic, copy) NSString *area_district_text;
@end
