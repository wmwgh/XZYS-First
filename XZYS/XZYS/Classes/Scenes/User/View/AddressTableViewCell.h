//
//  AddressTableViewCell.h
//  XZYS
//
//  Created by 杨利 on 16/9/23.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *numLab;
@property (strong, nonatomic) IBOutlet UIImageView *chooseImg;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UIButton *chooseBt;
@property (strong, nonatomic) IBOutlet UIButton *deleBt;
@property (strong, nonatomic) IBOutlet UIButton *editBt;




@end
