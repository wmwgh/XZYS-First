//
//  FLModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/19.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLModel : NSObject
/// 商品ID
@property (nonatomic, copy) NSString *cid;
/// 店铺ID
@property (nonatomic, copy) NSString *pid;
/// 商品名称
@property (nonatomic, copy) NSString *title;
/// 商品主图
@property (nonatomic, copy) NSString *img;

@end
