//
//  GwcShopModel.h
//  XZYS
//
//  Created by 杨利 on 16/8/31.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GwcShopModel : NSObject
@property (nonatomic, copy)NSString * shopTitle;//商品名称
@property (nonatomic, assign)float singlePrice;
@property (nonatomic, assign)BOOL selected;//店铺中的单个商品被选中
@property (nonatomic, assign)NSInteger count;
@end
