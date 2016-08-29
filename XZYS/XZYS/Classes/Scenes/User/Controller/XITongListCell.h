//
//  XITongListCell.h
//  XZYS
//
//  Created by 杨利 on 16/8/25.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XITongListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cellPic;
@property (strong, nonatomic) IBOutlet UILabel *decLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
