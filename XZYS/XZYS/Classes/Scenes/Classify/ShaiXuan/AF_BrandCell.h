//
//  AF_BrandCell.h
//  差五个让步
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 Elephant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AF_BrandCellDelegate <NSObject>

- (void)selectedValueChangeBlock:(NSInteger)section key:(NSInteger)index value:(NSString *)value;

@end

@interface AF_BrandCell : UITableViewCell

@property (assign, nonatomic) id<AF_BrandCellDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *attributeArr;

@property (strong, nonatomic) NSMutableArray *selectedArr;

@property (assign, nonatomic) CGFloat height;

@property (copy, nonatomic) NSString *isShrinkage;

/** cell 的类方法   返回 cell 本身  */
+ (instancetype) cellWithTableView: (UITableView *)tableView dataArr:(NSMutableArray*)arr indexPath:(NSIndexPath *)indexPath;
@end
