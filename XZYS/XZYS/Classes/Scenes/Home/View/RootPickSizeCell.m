//
//  RootPickSizeCell.m
//  choose
//
//  Created by 杨利 on 16/9/21.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "RootPickSizeCell.h"
#import "XZYS_Other.h"
@implementation RootPickSizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sizePickBt.layer.cornerRadius = 5;
    self.sizePickBt.backgroundColor = XZYSRGBColor(234, 234, 234);
    // Initialization code
}

- (IBAction)sizeAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sizeBt" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}

@end
