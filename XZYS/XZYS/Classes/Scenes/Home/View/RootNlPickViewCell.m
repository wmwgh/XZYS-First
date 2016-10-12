//
//  RootNlPickViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/10/10.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "RootNlPickViewCell.h"
#import "XZYS_Other.h"

@implementation RootNlPickViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.NLPickBt.layer.cornerRadius = 5;
    self.NLPickBt.backgroundColor = XZYSRGBColor(234, 234, 234);
    // Initialization code
}

- (IBAction)sizeAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nlBt" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}

@end
