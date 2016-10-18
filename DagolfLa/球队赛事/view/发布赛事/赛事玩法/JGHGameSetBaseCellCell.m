//
//  JGHGameSetBaseCellCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameSetBaseCellCell.h"

@implementation JGHGameSetBaseCellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ruleName.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    self.ruleNameLeft.constant = 40 *ProportionAdapter;
    self.ruleNameRight.constant = 10 *ProportionAdapter;
    self.ruleContectLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];

    self.rulesSetBtn.titleLabel.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    self.rulesSetBtnRight.constant = 10 *ProportionAdapter;
    
    self.rulesSetBtn.layer.masksToBounds = YES;
    self.rulesSetBtn.layer.cornerRadius = 3.0;
    self.rulesSetBtn.layer.borderWidth = 1;
    [self.rulesSetBtn.layer setBorderColor:[[UIColor colorWithHexString:Bar_Color] CGColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)rulesSetBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectGameSetBtn:sender];
    }
}

- (void)configJGHGameSetBaseCellCellContext:(NSDictionary *)dict{
//    self.ruleName.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
//    float rulesNameWSize = [Helper textWidthFromTextString:self.ruleName.text height:self.ruleName.frame.size.height fontSize:14 *ProportionAdapter];
//    self.ruleNameW.constant = rulesNameWSize +10;
    
    self.ruleContectLable.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
}

- (void)configJGHGameSetBaseCellCell:(NSDictionary *)dict{
    self.ruleName.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
    float rulesNameWSize = [Helper textWidthFromTextString:self.ruleName.text height:self.ruleName.frame.size.height fontSize:14 *ProportionAdapter];
    self.ruleNameW.constant = rulesNameWSize +10;
    
//    self.ruleContectLable.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"parentName"]];
}

@end
