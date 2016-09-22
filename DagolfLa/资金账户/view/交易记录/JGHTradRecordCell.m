//
//  JGHTradRecordCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTradRecordCell.h"
#import "JGHWithDrawModel.h"

@implementation JGHTradRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.time.font = [UIFont systemFontOfSize:15.0 * ProportionAdapter];
    self.name.font = [UIFont systemFontOfSize:17.0 * ProportionAdapter];
    self.monay.font = [UIFont systemFontOfSize:17.0 * ProportionAdapter];
    
    self.nameLeft.constant = 20 * ProportionAdapter;
    
    self.monayRight.constant = 20 * ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)congifData:(JGHWithDrawModel *)model{
    self.name.text = model.name;
    self.time.text = [Helper distanceTimeWithBeforeTime:model.exchangeTime];
    if (model.transType == 1) {
        self.monay.text = [NSString stringWithFormat:@"-%.2f", [model.amount floatValue]];
    }else{
        self.monay.text = [NSString stringWithFormat:@"+%.2f", [model.amount floatValue]];
    }
    
}

- (void)configJGHWithDrawModelWithDraw:(JGHWithDrawModel *)model{
    self.monay.hidden = YES;
    self.name.text = model.name;
//    self.time.text = [Helper formateDate:[Helper returnCurrentDateString] withFormate:model.exchangeTime];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


@end
