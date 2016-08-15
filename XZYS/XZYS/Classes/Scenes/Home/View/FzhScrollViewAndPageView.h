//
//  FzhScrollViewAndPageView.h
//  ceshi
//
//  Created by 付正 on 15/8/24.
//  Copyright (c) 2015年 付正. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FzhScrollViewDelegate;

@interface FzhScrollViewAndPageView : UIView<UIScrollViewDelegate>
{
    __unsafe_unretained id <FzhScrollViewDelegate> _delegate;
}

@property(nonatomic, assign)id <FzhScrollViewDelegate>delegate;

@property(nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)NSMutableArray *imageViewAry;
@property (nonatomic, readonly)UIScrollView *scrollView;
@property (nonatomic, readonly)UIPageControl *pageControl;

-(void)shouldAutoShow:(BOOL)shouldStart;


@end

@protocol FzhScrollViewDelegate <NSObject>

@optional
-(void)didClickPage:(FzhScrollViewAndPageView *)view atIndex:(NSInteger)index;

@end



