//
//  CZViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/9/27.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "CZViewCell.h"

@implementation CZViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorBtn.layer.cornerRadius = 5;
    self.colorBtn.backgroundColor = XZYSRGBColor(234, 234, 234);
    self.colorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    // Initialization code
}

- (IBAction)colorAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"czBt" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}
@end
