//
//  AddGoodsToTabViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/9/22.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "AddGoodsToTabViewCell.h"

@implementation AddGoodsToTabViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)deleAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleBt" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
