//
//  ShouHouModel.m
//  XZYS
//
//  Created by 杨利 on 16/10/5.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "ShouHouModel.h"

@implementation ShouHouModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
