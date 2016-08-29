//
//  YHRegular.h
//  task-06 正则表达式
//
//  Created by 至尊宝 on 16/6/11.
//  Copyright © 2016年 至尊宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHRegular : NSObject

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName:(NSString *)userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard:(NSString *)idCard;
#pragma 正则匹配URL
+ (BOOL)checkURL:(NSString *)url;
#pragma 正则匹配IP地址
+ (BOOL)checkIP:(NSString *)ip;

@end
