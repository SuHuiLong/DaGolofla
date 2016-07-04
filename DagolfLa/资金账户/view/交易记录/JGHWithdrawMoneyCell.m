//
//  JGHWithdrawMoneyCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWithdrawMoneyCell.h"
#import "JGHWithDrawModel.h"

@implementation JGHWithdrawMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.prices.font = [UIFont systemFontOfSize:35.0 * ProportionAdapter];
    self.propontLabel.font = [UIFont systemFontOfSize:17.0 * ProportionAdapter];
    
    self.pricesTop.constant = 20*ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGHWithDrawModelWithMonay:(NSNumber *)monay andTradeCatory:(NSInteger)tradeCatory{
    self.prices.text = [NSString stringWithFormat:@"%.2f", [monay floatValue]];
    
    // 未支付
    
    // 支付中
    
    // 支付成功
    
    // 支付失败
    
    // 订单关闭
    
    if (tradeCatory == 0) {
        self.propontLabel.text = @"提现申请";
    }else if (tradeCatory == 1){
        self.propontLabel.text = @"银行处理";
    }else if (tradeCatory == 2){
        self.propontLabel.text = @"银行处理";
    }else{
        self.propontLabel.text = @"提现失败";
    }
}


@end
