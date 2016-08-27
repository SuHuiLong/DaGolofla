//
//  JGHPalyTypeListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPalyTypeListCell.h"

@implementation JGHPalyTypeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.type.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.typeLeft.constant = 40 *ProportionAdapter;
    
    self.selectBtnRight.constant = 20 *ProportionAdapter;
    
    self.unitLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.unitLableRight.constant = 20 *ProportionAdapter;
    
    self.priceLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)selectBtn:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate selectPalysTypeListBtnClick:sender];
    }
    
}

- (void)configJGHPalyTypeListCell:(NSMutableDictionary *)dict{
    self.type.text = [dict objectForKey:@"costName"];
    self.priceLable.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"money"]];
    if ([[dict objectForKey:@"select"]integerValue] == 1) {
        [self.selectBtn setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
    }
}

@end
