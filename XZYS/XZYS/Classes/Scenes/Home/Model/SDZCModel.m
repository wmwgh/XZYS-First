//
//  SDZCModel.m
//  XZYS
//
//  Created by 杨利 on 16/8/9.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "SDZCModel.h"

@implementation SDZCModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
