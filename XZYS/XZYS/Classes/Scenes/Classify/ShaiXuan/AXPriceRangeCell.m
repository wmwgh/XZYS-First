//
//  AXPriceRangeCell.m
//  AXBaseMall
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 King. All rights reserved.
//

#import "AXPriceRangeCell.h"

#define textBackgroundColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]

@interface AXPriceRangeCell ()

@end

@implementation AXPriceRangeCell

- (void)awakeFromNib {
    // Initialization code
    [self.priceText1 setBackgroundColor:textBackgroundColor];
    self.priceText1.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceText1.returnKeyType =UIReturnKeyDone;
    
    [self.priceText2 setBackgroundColor:textBackgroundColor];
    self.priceText2.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceText2.returnKeyType =UIReturnKeyDone;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.priceText1 resignFirstResponder];
    [self.priceText2 resignFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
