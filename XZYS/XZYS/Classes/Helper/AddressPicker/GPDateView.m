//
//  GPDateView.m
//  Golf-PK
//
//  Created by XiongYiPing on 15/3/18.
//  Copyright (c) 2015年 exmart. All rights reserved.
//

#import "GPDateView.h"
#import "Const.h"
#import "UIViewExt.h"

#define TitleHeight 40.f

#define Key_Division        @"Division"
#define Key_DivisionCode    @"DivisionCode"
#define Key_DivisionName    @"DivisionName"
#define Key_DivisionSub     @"DivisionSub"
#define Key_DivisionVersion @"DivisionVersion"
#define KDistrictSelectNotification     @"KDistrictSelectNotification"

#define KDistrictSelectDistrict         @"KDistrictSelectDistrict"

@interface GPDateView ()
<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *handerView;
@property (nonatomic, assign) CGFloat ViewWidth;
@property (nonatomic, assign) CGFloat ViewHeight;
@property (nonatomic, assign) CGFloat originHeight;
@property (nonatomic, assign) CGFloat originWidth;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, strong) UILabel * titleLabel;



@property (nonatomic, strong) NSDictionary *districtDict;

@property (nonatomic, strong) NSString *provinceStr;
@property (nonatomic, strong) NSString *cityStr;
@property (nonatomic, strong) NSString *provinceSubCode;
@property (nonatomic, strong) NSString *provinceCode;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *districtStr;

@property (nonatomic, strong) NSArray *ProvinceArray;
@property (nonatomic, strong) NSArray *CityArray;
@property (nonatomic, strong) NSArray *districtArray;



@end

@implementation GPDateView

-(id)initWithFrame:(CGRect)frame Data:(NSArray *)dataArr
{
    self = [super init];
    if (self) {
        self.ViewWidth  = frame.size.width - 20;
        self.ViewHeight = frame.size.height;
        self.originHeight = frame.origin.y;
        self.dataArr = dataArr;
        
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.ViewWidth)/2,([UIScreen mainScreen].bounds.size.height - self.ViewHeight)/2, self.ViewWidth, self.ViewHeight);
    }
    return self;
}

-(UIPickerView *)pickerView
{
    if (_pickerView!= nil) {
        return _pickerView;
    }
    
    _pickerView = [[UIPickerView alloc] initWithFrame:[self getMainViewFrame]];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    return _pickerView;
}



-(CGRect)getMainViewFrame
{
    CGRect rect = self.frame;
    rect.origin.x = (self.width - self.ViewWidth) / 2.0;
    rect.origin.y = TitleHeight;
    rect.size.width = self.ViewWidth;
    rect.size.height = self.ViewHeight;
//    rect.size.height = self.ViewHeight - TitleHeight;
    return rect;
}

-(UIView *)titleView
{
    if (_titleView!=nil) {
        return _titleView;
    }
    CGRect rect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = self.ViewWidth;
    rect.size.height = TitleHeight;
    _titleView = [[UIView alloc] initWithFrame:rect];
    _titleView.backgroundColor = RGB(249, 249, 249);
    if (self.titlePic) {
        UIImageView * titlePic = [[UIImageView alloc] initWithFrame:rect];
        titlePic.image = [UIImage imageNamed:self.titlePic];
        [_titleView addSubview:titlePic];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:self.btnImage] forState:UIControlStateNormal];
        btn.frame = CGRectMake(self.ViewWidth-40, 9 , 24, 24);
        [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btn];
    }
    else
    {
        UIButton * quxiaobtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quxiaobtn.frame = CGRectMake(5, 9, 55, 24);
        quxiaobtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [quxiaobtn setTitle:@"取消" forState:UIControlStateNormal];
        [quxiaobtn setTitleColor:ALLGRAYCOLOR forState:UIControlStateNormal];
        quxiaobtn.backgroundColor = [UIColor clearColor];
        quxiaobtn.layer.cornerRadius = 5;
        [quxiaobtn addTarget:self action:@selector(btnDownCancel) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:quxiaobtn];
        [_titleView bringSubviewToFront:quxiaobtn];

        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.ViewWidth-60, 9, 55, 24);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:ALLOrangeCOLOR forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btn];
        
        [_titleView bringSubviewToFront:btn];
    }
    return _titleView;
}

-(void)show
{
    self.layer.masksToBounds = YES;
    //设置角度
    self.layer.cornerRadius = 9 ;
    if (!self.titlePic) {
//        self.layer.borderColor = RGB(144, 86, 140).CGColor; //描边
//        self.layer.borderWidth = 1;
    }
    
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _handerView.backgroundColor = [UIColor blackColor];
    _handerView.alpha = 0.3;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    [window addSubview:self];
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
    
}


-(void)showPickerView
{
    self.districtDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"districtMGE" ofType:@"plist"]];
    self.ProvinceArray = self.districtDict[Key_Division];
    [self addSubview:self.titleView];
    [self addSubview:self.pickerView];
    [self show];
}
-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    
    if (_pickerView) {
        NSString * provinceCode = [self.ProvinceArray[[_pickerView selectedRowInComponent:0]] objectForKey:Key_DivisionCode];
        NSString * cityCode = [self.CityArray[[_pickerView selectedRowInComponent:1]] objectForKey:Key_DivisionCode];
        
        NSString * citySubCode = [self.districtArray[[_pickerView selectedRowInComponent:2]] objectForKey:Key_DivisionCode];
    
        NSString *provinceName = [self.ProvinceArray[[_pickerView selectedRowInComponent:0]] objectForKey:Key_DivisionName];
        NSString *cityName = [self.CityArray[[_pickerView selectedRowInComponent:1]] objectForKey:Key_DivisionName];
        NSString *citySubName = [self.districtArray[[_pickerView selectedRowInComponent:2]] objectForKey:Key_DivisionName];
        NSString *areaTitle = [NSString stringWithFormat:@"%@%@",provinceName,citySubName];
        if (self.ActionDistrictViewSelectBlock) {
            self.ActionDistrictViewSelectBlock(areaTitle,@{Key_DistrictSelectProvince:provinceName,
                                                     Key_DistrictSelectProvinceCode:provinceCode,
                                                     Key_DistrictSelectCity:cityName,
                                                     Key_DistrictSelectCityCode:cityCode,
                                                     Key_DistrictSelectProvinceSub:citySubName,
                                                     Key_DistrictSelectProvinceSubCode:citySubCode
                                                     });
        }
        
    }
    if (!animate) {
        [_handerView removeFromSuperview];
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
    
    
}

-(void)btnDown
{
    [self dismiss];
}

-(void)btnDownCancel
{
    
//        [_handerView removeFromSuperview];
//        [self removeFromSuperview];
//        return;
    
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
        [self removeFromSuperview];
    }];
}



#pragma mark -
#pragma mark Picker Data Source Methods

- (void)getSelectDistrictName
{
    NSDictionary *ProvinceDict = self.ProvinceArray[[_pickerView selectedRowInComponent:0]];
    self.provinceStr = [ProvinceDict objectForKey:Key_DivisionName];
    
    //*****
    
    NSArray *array = [ProvinceDict objectForKey:Key_DivisionSub];
    if ([_pickerView selectedRowInComponent:1] > array.count - 1) {
        return;
    }
    NSDictionary *CityDict = [[ProvinceDict objectForKey:Key_DivisionSub] objectAtIndex:[_pickerView selectedRowInComponent:1]];
    self.cityStr = [CityDict objectForKey:Key_DivisionName];
    self.districtStr = [self.districtArray[[_pickerView selectedRowInComponent:2]] objectForKey:Key_DivisionName];//****
    _titleLabel.text = [NSString stringWithFormat:@"%@%@%@",self.provinceStr,self.cityStr,self.districtStr];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        return self.ProvinceArray.count;
    }
    else if(component==1)
    {
        if ([pickerView selectedRowInComponent:0]==-1)
        {
            return 0;
        }
        else
        {
            NSDictionary *ProvinceDict = self.ProvinceArray[[_pickerView selectedRowInComponent:0]];
            self.CityArray = [ProvinceDict objectForKey:Key_DivisionSub];
            
            return [self.CityArray count];
        }
    }
    else
    {
        if ([pickerView selectedRowInComponent:1]==-1)
        {
            return 0;
        }
        else
        {
            NSDictionary *CityDict = self.CityArray[[_pickerView selectedRowInComponent:1]];
            self.districtArray = [CityDict objectForKey:Key_DivisionSub];
            return self.districtArray.count;
        }
    }
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    if (component==0)
    {
        NSDictionary *ProvinceDict = self.ProvinceArray[row];
        title = [ProvinceDict objectForKey:Key_DivisionName];
        
    }
    else if(component ==1)
    {
        NSDictionary *CityDict = self.CityArray[row];
        title = [CityDict objectForKey:Key_DivisionName];
    }
    else
    {
        NSDictionary *DistrictDict = self.districtArray[row];
        title = [DistrictDict objectForKey:Key_DivisionName];
    }
    return title ? title : @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        [pickerView reloadComponent:1];
        
        [pickerView reloadComponent:2];//***
        [self getSelectDistrictName];
    }
    else if(component==1)
    {
        [pickerView reloadComponent:2];//***
        [self getSelectDistrictName];
    }
    else
    {
        [self getSelectDistrictName];
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 70.0;
}


@end

















