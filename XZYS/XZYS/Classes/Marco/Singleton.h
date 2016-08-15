//
//  Singleton.h
//  XZYS
//
//  Created by 杨利 on 16/8/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

// 单例声明
#define singleton_interface(className)\
+ (instancetype)share##className;
// 单例实现
#define singleton_implementation(className)\
static className *manager;\
+ (instancetype)share##className {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
manager = [[className alloc] init];\
});\
return manager;\
}

#endif /* Singleton_h */
