//
//  SonLislModel.m
//  XZYS
//
//  Created by 杨利 on 16/9/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "SonLislModel.h"

@implementation SonLislModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
