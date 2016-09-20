//
//  AF_BrandCell.m
//  差五个让步
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 Elephant. All rights reserved.
//

#import "AF_BrandCell.h"

#define offset [UIScreen mainScreen].bounds.size.width - 50
#define buttonBackgroundColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]

@interface AF_BrandCell ()
{
    NSMutableArray *buttonArr;
}

@end

@implementation AF_BrandCell

+ (instancetype)cellWithTableView:(UITableView *)tableView dataArr:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath
{
    NSString *baseCell = [NSString stringWithFormat:@"Brand%ld", indexPath.section];
    AF_BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCell];
    if (!cell) {
        cell = [[AF_BrandCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCell dataArr:arr];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dataArr:(NSMutableArray *)arr
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        buttonArr = [NSMutableArray array];
        for (int i=0; i< arr.count; i++) {
            UIButton *button = [[UIButton alloc]init];
            [button setBackgroundColor:buttonBackgroundColor];
            button.titleLabel.font = [UIFont systemFontOfSize:13.0];
            button.tag = i;
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 5.0;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            //是否展开选项
            if ([self.isShrinkage isEqualToString:@"YES"]) {
                button.hidden = NO;
            }else {
                if (i > 2) {
                    button.hidden = YES;
                }
            }
            [buttonArr addObject:button];
        }
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    if (!button.selected) {
        button.selected = YES;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor redColor].CGColor;
        [self.delegate selectedValueChangeBlock:self.tag key:button.tag value:@"YES"];
    }else {
        button.selected = NO;
        [button setBackgroundColor:buttonBackgroundColor];
        button.layer.borderWidth = 0.0;
        [self.delegate selectedValueChangeBlock:self.tag key:button.tag value:@"NO"];
    }
}

- (void)setSelectedArr:(NSMutableArray *)selectedArr
{
    for (int i = 0; i < selectedArr.count; i++) {
        UIButton *button = buttonArr[i];
        //是否为选中状态
        NSString *selectedStr = selectedArr[i];
        if ([selectedStr isEqualToString:@"YES"]) {
            button.selected = YES;
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor redColor].CGColor;
        }else {
            button.selected = NO;
            [button setBackgroundColor:buttonBackgroundColor];
            button.layer.borderWidth = 0.0;
        }
    }
}

- (void)setAttributeArr:(NSMutableArray *)attributeArr
{
    /** 九宫格布局算法 */
    CGFloat spacing = 5.0;//行、列 间距
    int totalloc = 3;//列数
    CGFloat appvieww = (offset - spacing*4)/totalloc;
    CGFloat appviewh = 30;
    int row = 0 ;
    for (int i=0; i< attributeArr.count; i++) {
        row = i/totalloc;//行号
        int loc = i%totalloc;//列号
        
        CGFloat appviewx = spacing + (spacing + appvieww) * loc;
        CGFloat appviewy = spacing + (spacing + appviewh) * row;
        
        UIButton *button = buttonArr[i];
        
        button.frame = CGRectMake(appviewx, appviewy, appvieww, appviewh);
        
        [button setTitle:attributeArr[i] forState:UIControlStateNormal];
        
        if ([self.isShrinkage isEqualToString:@"YES"]) {
            button.hidden = NO;
        }else {
            if (i > 2) {
                button.hidden = YES;
            }
        }
    }
    if ([self.isShrinkage isEqualToString:@"YES"]) {
        _height = (spacing + appviewh) * (row + 1) + spacing;
    }else {
        _height = 40;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
