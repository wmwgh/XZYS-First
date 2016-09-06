//
//  GPDateView.h
//  Golf-PK
//
//  Created by XiongYiPing on 15/3/18.
//  Copyright (c) 2015年 exmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPDateView : UIView
@property (nonatomic,copy) NSString * btnImage;;
@property (nonatomic,copy) NSString * titleImage;
@property (nonatomic,copy) NSString * titleStr;
@property (nonatomic,copy) NSString * titlePic;
@property (nonatomic, copy) void(^ActionDistrictViewSelectBlock)(NSString *desStr,NSDictionary *selectDistrictDict);


@property (nonatomic, copy) NSString *teamStatu;

-(id)initWithFrame:(CGRect)frame Data:(NSArray *)dataArr;

-(void)showPickerView;


@end
