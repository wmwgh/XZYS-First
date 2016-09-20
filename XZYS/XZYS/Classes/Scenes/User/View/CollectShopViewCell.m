//
//  CollectShopViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/9/18.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "CollectShopViewCell.h"
#import "XIangQingViewController.h"

@implementation CollectShopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)bt1:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bt1" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}
- (IBAction)bt2:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bt2" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}
- (IBAction)bt3:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bt3" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}
- (IBAction)bt4:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bt4" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}
- (IBAction)bt5:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bt5" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
