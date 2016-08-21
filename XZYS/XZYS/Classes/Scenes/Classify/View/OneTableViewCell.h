//
//  OneTableViewCell.h
//  XZYS
//
//  Created by 杨利 on 16/8/20.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@end
