//
//  ShopCarModel.h
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/25.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarModel : NSObject

@property (nonatomic, strong)NSMutableArray * listArr;
@property (nonatomic, copy)NSString * dianpuTitle;
@property (nonatomic, assign)BOOL isChecked;//店铺被选中
@end
