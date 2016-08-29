//
//  ShopModel.m
//  XZYS
//
//  Created by 杨利 on 16/8/29.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
