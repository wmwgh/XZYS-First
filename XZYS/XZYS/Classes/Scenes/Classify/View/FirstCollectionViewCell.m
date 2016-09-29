//
//  FirstCollectionViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/9/28.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "FirstCollectionViewCell.h"

@implementation FirstCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstText.textAlignment = NSTextAlignmentCenter;
    self.secondText.textAlignment = NSTextAlignmentCenter;
    [self.secondText addTarget:self action:@selector(endEdit) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)endEdit {
    NSString *str1 = self.firstText.text;
    NSString *str2 = self.secondText.text;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"1"] = str1;
    dic[@"2"] = str2;
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jgBt" object:self userInfo:[NSDictionary dictionaryWithObject:dic forKey:@"sid"]];
}

@end
