//
//  XITongListCell.m
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "XITongListCell.h"

@implementation XITongListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellPic.layer.cornerRadius = 10;
    self.cellPic.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
