//
//  CollectModel.m
//  XZYS
//
//  Created by 杨利 on 16/9/18.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
