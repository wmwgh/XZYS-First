//
//  SDFQCollectionViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/8/11.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "SDFQCollectionViewCell.h"

@implementation SDFQCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor purpleColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 5, CGRectGetWidth(self.frame)- 5, CGRectGetWidth(self.frame)- 5)];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imgView];
        
        self.tittleLable = [[UILabel alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(self.imgView.frame) + 3, CGRectGetWidth(self.frame) - 5, 35)];
        self.tittleLable.backgroundColor = [UIColor brownColor];
        [self addSubview:self.tittleLable];
        
        
        self.priceLable = [[UILabel alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(self.tittleLable.frame) + 3, 40, 20)];
        self.priceLable.backgroundColor = [UIColor brownColor];
        [self addSubview:self.priceLable];
        
        self.NumberLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 42, CGRectGetMaxY(self.NumberLable.frame) + 3, 40, 20)];
        self.NumberLable.backgroundColor = [UIColor brownColor];
        [self addSubview:self.NumberLable];
    }
    return self;
}
@end
