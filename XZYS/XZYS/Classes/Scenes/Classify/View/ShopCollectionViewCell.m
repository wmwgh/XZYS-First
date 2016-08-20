//
//  ShopCollectionViewCell.m
//  商品列表
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 YF_S. All rights reserved.
//

#import "ShopCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XZYS_URL.h"

@implementation ShopCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShopCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    return self;
}

-(void)setOneModel:(FLModel *)oneModel{

    _oneModel = oneModel;
    NSString *str = [NSString stringWithFormat:@"%@%@", XZYS_PJ_URL, _oneModel.img];
    [_imgV sd_setImageWithURL:[NSURL URLWithString:str]];
    _nameLabel.text = _oneModel.title;
}

@end
