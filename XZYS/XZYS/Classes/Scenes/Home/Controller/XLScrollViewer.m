//
//  XLScrollView.m
//  XLScrollDemo
//

#define screen_width [UIScreen mainScreen].bounds.size.width

#import "XLScrollViewer.h"

@interface XLScrollViewer ()<UIScrollViewDelegate>
{
    int _x;
    CGFloat _x0;
}
@property(nonatomic,strong)UIScrollView *scroll1;
@property(nonatomic,strong)UIScrollView *scroll2;
@property(nonatomic,strong)UIView *view2;

@property(nonatomic ,strong)NSMutableArray *buttons;

@end

@implementation XLScrollViewer

-(instancetype)initWithFrame:(CGRect)frame withViews:(NSArray *)views withButtonNames:(NSArray *)names withThreeAnimation:(int)choose{
    self =[super initWithFrame:frame];
    if (self) {
        self.xl_views =views;
        self.xl_buttonNames =names;
    }
    return self;
}

+(instancetype)scrollWithFrame:(CGRect)frame withViews:(NSArray *)views withButtonNames:(NSArray *)names withThreeAnimation:(int)choose{
    return [[self alloc]initWithFrame:frame withViews:views withButtonNames:names withThreeAnimation:choose];
}

-(void)drawRect:(CGRect)rect {
    [self addScroll2];
    [self addScroll1];
}

-(void)addScroll1{
    
    self.scroll1 =[[UIScrollView alloc]initWithFrame:CGRectMake(50, 0, screen_width - 100, 44)];

    self.scroll1.contentSize = CGSizeMake(screen_width - 50, 0);
    self.scroll1.showsHorizontalScrollIndicator =NO;
    self.scroll1.showsVerticalScrollIndicator =NO;
    self.scroll1.bounces =NO;
    self.scroll1.contentOffset=CGPointZero;
    self.scroll1.scrollsToTop =NO;
    
    self.buttons =[NSMutableArray array];
    for (int i =0; i<self.xl_buttonNames.count; i++) {
        UIButton *temp =[UIButton buttonWithType:UIButtonTypeCustom];
        
        temp.frame =CGRectMake((screen_width - 100)/3*i, 0, self.frame.size.width / 3, 44);
        temp.backgroundColor = [UIColor brownColor];
        temp.titleLabel.font =[UIFont systemFontOfSize:self.xl_buttonFont?self.xl_buttonFont:18];
        [temp setTitle:self.xl_buttonNames[i] forState:UIControlStateNormal];
        [temp setTitleColor:self.xl_buttonColorNormal?self.xl_buttonColorNormal:[UIColor blackColor] forState:UIControlStateNormal];
        [temp setTitleColor:self.xl_buttonColorSelected?self.xl_buttonColorSelected:XZYSBlueColor forState:UIControlStateSelected];
        if (i == 0) {
            temp.selected = YES;
            [temp setTitleColor:self.xl_buttonColorSelected?self.xl_buttonColorSelected:XZYSBlueColor forState:UIControlStateNormal];
        }
        [temp addTarget:self action:@selector(changed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll1 addSubview:temp];
        [self.buttons addObject:temp];
    }
    
    CGSize size0 =[self.xl_buttonNames[0] sizeWithAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:self.xl_buttonFont?self.xl_buttonFont:18]}];
    
    UIButton *button0 = self.buttons[0];
    _x0 = button0.center.x - size0.width/2;
    self.view2 =[[UIView alloc]initWithFrame:CGRectMake(_x0,CGRectGetMaxY(button0.frame)-(self.xl_buttonToSlider?self.xl_buttonToSlider:10), size0.width, self.xl_sliderHeight?self.xl_sliderHeight:2)];
    self.view2.backgroundColor =self.xl_sliderColor?self.xl_sliderColor:[UIColor greenColor];;
    [self.scroll1 addSubview:self.view2];
    
    [self addSubview:self.scroll1];
}

-(void)addScroll2{
    self.scroll2 =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, screen_width, self.frame.size.height - 44)];
    self.scroll2.contentOffset = CGPointZero;
    self.scroll2.contentSize = CGSizeMake(screen_width*3, 0);
    self.scroll2.showsHorizontalScrollIndicator = NO;
    self.scroll2.showsVerticalScrollIndicator = NO;
    self.scroll2.delegate = self;
    self.scroll2.pagingEnabled = YES;
    self.scroll2.bounces = NO;
    self.scroll2.scrollsToTop = NO;
    
    for (int i =0; i<self.xl_buttonNames.count; i++) {
        
        if (!self.xl_views) {
            UIView *temp =[[UIView alloc]initWithFrame:CGRectMake(0, 44, screen_width, self.scroll2.frame.size.height)];
            [self.scroll2 addSubview:temp];
            
        }else {
            UIView *temp = self.xl_views[i];
            temp.frame =(CGRect){{screen_width*i, 0},self.scroll2.frame.size};
            [self.scroll2 addSubview:temp];
        }
    }
   
    [self addSubview:self.scroll2];
}

-(void)changed:(UIButton *)button{
    
    if (self.xl_isScaleButton) {
        if (!button.selected) {
            [UIView animateWithDuration:0.2 animations:^{
                button.transform =CGAffineTransformScale(button.transform, 0.7, 0.7);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    button.transform =CGAffineTransformScale(button.transform, 1/0.6, 1/0.6);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        button.transform =CGAffineTransformScale(button.transform, 1/0.7*0.6, 1/0.7*0.6);
                    }];
                }];
            }];
        }
    }
    
    for (UIButton *temp in self.buttons) {
        
        if (temp.selected && temp !=button) {
            temp.selected = NO;
        }
        if (temp ==button) {
            [temp setTitleColor:self.xl_buttonColorSelected?self.xl_buttonColorSelected:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
            [temp setTitleColor:self.xl_buttonColorNormal?self.xl_buttonColorNormal:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    button.selected = YES;
    
    self.scroll2.delegate = nil;
    
    // 偏移设置
    self.scroll2.contentOffset =CGPointMake(screen_width * self.xl_buttonNames.count, 0);
    
    CGSize size =[button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:self.xl_buttonFont?self.xl_buttonFont:18]}];
    // 底部滑动条
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect =self.view2.frame;
        rect.size.width =size.width;
        self.view2.frame =rect;
        self.view2.transform =CGAffineTransformMakeTranslation(button.frame.origin.x +button.frame.size.width/2 -size.width/2 -_x0, 0);
    }];
    
    
    self.scroll2.delegate = self;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _x = scrollView.contentOffset.x / screen_width;
    NSLog(@"%d", _x);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UIButton *button =self.buttons[_x];
    [button setTitleColor:self.xl_buttonColorNormal?self.xl_buttonColorNormal:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGPoint point= self.scroll2.contentOffset;
    point.y = 0;
    self.scroll2.contentOffset = point;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    

    
    for (UIButton *temp in self.buttons) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            temp.transform =CGAffineTransformMakeTranslation(0, 0);
        }];
        
        if (temp.selected) {
            temp.selected =NO;
        }
        
        int x1 =temp.frame.origin.x;
        int x2 =0;
        if (self.xl_buttonNames.count <=5) {
            x2 =scrollView.contentOffset.x/self.xl_buttonNames.count;
        }else {
            x2 =scrollView.contentOffset.x/5;
        }
        
        
        if (x1 == x2) {
            
            temp.selected =YES;
            [temp setTitleColor:self.xl_buttonColorSelected?self.xl_buttonColorSelected:[UIColor whiteColor] forState:UIControlStateNormal];
            
            CGSize size =[temp.titleLabel.text sizeWithAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:self.xl_buttonFont?self.xl_buttonFont:18]}];
            [UIView animateWithDuration:0.2 animations:^{
                CGRect rect =self.view2.frame;
                rect.size.width =size.width;
                self.view2.frame =rect;
                self.view2.transform =CGAffineTransformMakeTranslation(temp.frame.origin.x +temp.frame.size.width/2 -size.width/2 -_x0, 0);
            }];
        }
    }
    
    UIButton *button =self.buttons[_x];
    int xAfter =scrollView.contentOffset.x/screen_width;
    if (_x<xAfter) {
        if (_x>=2 && _x<=self.xl_buttonNames.count-4 ) {
            [UIView animateWithDuration:0.2 animations:^{
                self.scroll1.contentOffset =CGPointMake(button.center.x -screen_width/5*1.5, 0);
            }];
        }
    }else if (_x>xAfter) {
        if (_x>=3 && _x<=self.xl_buttonNames.count-2 ) {
            [UIView animateWithDuration:0.2 animations:^{
                self.scroll1.contentOffset =CGPointMake(button.center.x -screen_width/5*3.5, 0);
            }];
        }
    }
}



@end


