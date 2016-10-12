//
//  RequestShouHouController.h
//  XZYS
//
//  Created by 杨利 on 16/9/11.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestShouHouController : UIViewController
@property (nonatomic , copy) NSString *orderID;
@property (nonatomic , copy) NSString *goodsID;
@property (strong, nonatomic) IBOutlet UIButton *tuihuoBt;
@property (strong, nonatomic) IBOutlet UIButton *huanhuoBt;
@property (strong, nonatomic) IBOutlet UIButton *weixiuBt;
@property (strong, nonatomic) IBOutlet UITextField *numText;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UITextView *reaseonText;
@property (strong, nonatomic) IBOutlet UILabel *tuihuoLab;
@property (strong, nonatomic) IBOutlet UILabel *huanhuoLab;
@property (strong, nonatomic) IBOutlet UILabel *weixiuLab;

@end
