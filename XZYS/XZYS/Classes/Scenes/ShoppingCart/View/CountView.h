//
//  CountView.h
//  ShopCarDemo
//
//  Created by 周智勇 on 16/7/26.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountView : UIView
@property (nonatomic, strong)UIButton * leftBtn;
@property (nonatomic, strong)UIButton * rightBtn;
@property (nonatomic, strong)UITextField * countTF;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, copy)void (^CountBlock)(NSInteger num);
@end
