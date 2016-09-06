//
//  Const.h
//
//  Created by sjq on 15/2/9.
//  Copyright (c) 2015年 sjq. All rights reserved.
//

#ifndef FanMeiMei_Const_h
#define FanMeiMei_Const_h

//-----------------------------------------------------------
#pragma mark -
#pragma mark - Default And System

#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define ALLBLUECOLOR    [UIColor colorWithRed:(0)/255.f green:(171)/255.f blue:(235)/255.f alpha:1.f]
#define ALLBLACKCOLOR    [UIColor colorWithRed:(50)/255.f green:(45)/255.f blue:(45)/255.f alpha:1.f]
#define ALLGRAYCOLOR    [UIColor colorWithRed:(165)/255.f green:(164)/255.f blue:(160)/255.f alpha:1.f]
#define ALLBeiJingCOLOR    [UIColor colorWithRed:(244)/255.f green:(243)/255.f blue:(238)/255.f alpha:1.f]
#define ALLGreenCOLOR    [UIColor colorWithRed:(193)/255.f green:(217)/255.f blue:(105)/255.f alpha:1.f]
#define ALLOrangeCOLOR    [UIColor colorWithRed:(240)/255.f green:(131)/255.f blue:(0)/255.f alpha:1.f]
#define ALLFenSeCOLOR    [UIColor colorWithRed:(215)/255.f green:(0)/255.f blue:(52)/255.f alpha:1.f]
#define ALLLittleYellowCOLOR    [UIColor colorWithRed:(254)/255.f green:(242)/255.f blue:(210)/255.f alpha:1.f]




#define DefaultPageSize         10
#define DefaultPlatform         [NSNumber numberWithInt:1]
#define DefaultSystemVersion    [[UIDevice currentDevice]systemVersion]
#define DeviceHeight            [[UIScreen mainScreen] bounds].size.height
#define DeviceWidth             [[UIScreen mainScreen] bounds].size.width

#define AutoSizeScaleX          [[UIScreen mainScreen] bounds].size.width/320.0
#define AutoSizeScaleY          [[UIScreen mainScreen] bounds].size.height/568.0




#define Key_DistrictSelectProvince          @"DistrictSelectProvince"
#define Key_DistrictSelectProvinceCode      @"DistrictSelectProvinceCode"
#define Key_DistrictSelectProvinceSubCode   @"DistrictSelectProvinceSubCode"
#define Key_DistrictSelectProvinceSub       @"DistrictSelectProvinceSub"
#define Key_DistrictSelectCityCode          @"DistrictSelectCityCode"
#define Key_DistrictSelectCity              @"DistrictSelectCity"

#define Error_Bad_Net @"您的操作无法完成,请在网络畅通网速良好的环境下重新操作"

#endif
