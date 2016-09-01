//
//  AF_ScreeningViewController.h
//  差五个让步
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 Elephant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AF_ScreeningViewControllerDelegate <NSObject>
//确定代理
- (void)determineButtonTouchEvent;

@end

@interface AF_ScreeningViewController : UIViewController

@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) id<AF_ScreeningViewControllerDelegate> delegate;

@end

