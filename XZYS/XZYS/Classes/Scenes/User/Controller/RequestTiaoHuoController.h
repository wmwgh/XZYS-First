//
//  RequestTiaoHuoController.h
//  XZYS
//
//  Created by 杨利 on 16/9/11.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestTiaoHuoController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *numText;
@property (strong, nonatomic) IBOutlet UITextField *priceText;
@property (strong, nonatomic) IBOutlet UITextField *shopText;
@property (strong, nonatomic) IBOutlet UITextField *contectText;
@property (strong, nonatomic) IBOutlet UITextField *telText;
@property (strong, nonatomic) IBOutlet UITextView *addressText;
@property (nonatomic , copy) NSString *orderID;
@property (nonatomic , copy) NSString *goodsID;
@end
