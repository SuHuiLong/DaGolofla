//
//  JGHNewCostListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNewCostListCell.h"

@implementation JGHNewCostListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.oneTextField.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.oneTextFieldLeft.constant = 10 *ProportionAdapter;
    self.oneTextFieldRight.constant = 30 *ProportionAdapter;
    
    self.twoTextField.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.twoTextFieldRight.constant = 10 *ProportionAdapter;
    self.twoTextFieldW.constant = 90 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configTextFeilSpeaclerText:(NSMutableDictionary *)dict{
    NSString *costName = [dict objectForKey:@"costName"];
    NSString *money = [dict objectForKey:@"money"];
    
//    self.oneTextField.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"costName"]];
    if (![money isEqualToString:@""]) {
        self.twoTextField.text = money;
    }else{
        self.twoTextField.placeholder = @"请输入金额";
    }
    
    if (![costName isEqualToString:@""]) {
        self.oneTextField.text = costName;
    }else{
        self.oneTextField.placeholder = @"请输入资费名称";
    }
}

- (void)configTextFeilSpeacler{
    self.twoTextField.placeholder = @"请输入金额";
    self.oneTextField.placeholder = @"请输入资费名称";
}

@end
