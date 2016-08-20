//
//  GuiGeView.m
//  XZYS
//
//  Created by 杨利 on 16/8/18.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "GuiGeView.h"

@implementation GuiGeView


-(void)setOneModel:(SPXQModel *)oneModel{
    NSLog(@"123-===%@", oneModel);
    _model = oneModel;
//    _chicun.text = _model.goods_sn;
//    _yanse.text = _model.material;
    NSLog(@"123----%@", _model.linmater);
    _xiemiancailiao.text = _model.material;
    _xiegenleixing.text = _model.heel;
    _gongneng.text = _model.function;
    _fengge.text = _model.style;
    _xietoukuanshi.text = _model.topstyle;
    _xiedicaizhi.text = _model.solematerial;
    _xielicaizhi.text = _model.linmater;
    _shiYong.text = _model.audience;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
