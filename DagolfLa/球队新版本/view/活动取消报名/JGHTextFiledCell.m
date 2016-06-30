//
//  JGHTextFiledCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTextFiledCell.h"

@implementation JGHTextFiledCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configViewTitles{
    self.titles.text = @"退款理由";
    self.titlefileds.placeholder = @"请输入退款理由";
}

- (void)configViewWithDraw:(NSNumber *)monay{
    self.titles.text = @"金额";
    self.titles.textColor = [UIColor blackColor];
    self.titleLeft.constant = 20 *ProportionAdapter;
    
    self.titlefiledsRight.constant = 20 *ProportionAdapter;
    
    self.titlefileds.keyboardType = UIKeyboardTypeWebSearch;
    self.titlefileds.placeholder = [NSString stringWithFormat:@"当前可提现金额为%.2f元", [monay floatValue]];
}

- (void)configPayPassword{
    self.titles.text = @"支付密码";
    self.titlefileds.placeholder = @"输入付款时的支付密码";
    self.titleLeft.constant = 20 *ProportionAdapter;
    
    self.titlefiledsRight.constant = 20 *ProportionAdapter;
}

@end
