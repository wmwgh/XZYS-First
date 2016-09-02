//
//  OneTableViewCell.m
//  XZYS
//
//  Created by 杨利 on 16/8/20.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "OneTableViewCell.h"



@implementation OneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.picImageView.layer.cornerRadius = 5;
    self.picImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
