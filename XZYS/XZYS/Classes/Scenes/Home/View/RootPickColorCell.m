//
//  RootPickColorCell.m
//  choose
//
//  Created by 杨利 on 16/9/21.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "RootPickColorCell.h"
#import "XZYS_Other.h"

@implementation RootPickColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorBtn.layer.cornerRadius = 5;
    self.colorBtn.backgroundColor = XZYSRGBColor(234, 234, 234);
    // Initialization code
}

- (IBAction)colorAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"colorBt" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}


@end
