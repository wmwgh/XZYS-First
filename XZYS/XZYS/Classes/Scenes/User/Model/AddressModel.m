//
//  AddressModel.m
//  XZYS
//
//  Created by 杨利 on 16/9/23.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
