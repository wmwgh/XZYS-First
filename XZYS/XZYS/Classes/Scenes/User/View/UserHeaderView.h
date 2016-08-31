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

@property (strong, nonatomic) IBOutlet UIButton *changeInfo;
@property (strong, nonatomic) IBOutlet UIButton *changePassWord;
@property (strong, nonatomic) IBOutlet UIButton *allListButton;
@property (strong, nonatomic) IBOutlet UIButton *daiPayButton;
@property (strong, nonatomic) IBOutlet UIButton *daiReceiveButton;
@property (strong, nonatomic) IBOutlet UIButton *yiPayButton;
@property (strong, nonatomic) IBOutlet UIButton *yiComplateButton;

@property (nonatomic,strong) UIViewController *owner;


@end
