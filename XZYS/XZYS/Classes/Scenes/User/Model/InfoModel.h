//
//  InfoModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/24.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject
/// 用户名称
@property (nonatomic, copy) NSString *nickname;
/// 电子邮箱
@property (nonatomic, copy) NSString *email;
/// 头像
@property (nonatomic, copy) NSString *member_picture;
/// 性别ID
@property (nonatomic, copy) NSString *sex;
/// 地区-省ID
@property (nonatomic, copy) NSString *area_province;
/// 地区-市ID
@property (nonatomic, copy) NSString *area_city;
/// 地区-县ID
@property (nonatomic, copy) NSString *area_district;
/// 详细地址
@property (nonatomic, copy) NSString *shop_address;
/// 性别
@property (nonatomic, copy) NSString *sex_text;
/// 地区-县
@property (nonatomic, copy) NSString *area_district_text;
/// 地区-省
@property (nonatomic, copy) NSString *area_province_text;
/// 地区-市
@property (nonatomic, copy) NSString *area_city_text;
@end
