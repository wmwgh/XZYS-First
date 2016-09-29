//
//  AddressTableViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/9/23.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)chooseBtAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseBt" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}

- (IBAction)editBtAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editBt" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}

- (IBAction)deleBtAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", sender.tag];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleBt" object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"sid"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
