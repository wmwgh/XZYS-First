//
//  UserHeaderView.h
//  XZYS
//
//  Created by 杨利 on 16/8/22.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UIImageView *headerImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *jifen;

@end
