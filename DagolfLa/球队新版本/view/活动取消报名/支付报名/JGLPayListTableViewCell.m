//
//  JGLPayListTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPayListTableViewCell.h"

@implementation JGLPayListTableViewCell
{
    BOOL _isClick;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _isClick = NO;
    
    [_stateBtn addTarget:self action:@selector(stateClick:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark --勾选打球人
-(void)stateClick:(UIButton *)btn
{
    if (_isClick == NO) {
        [btn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
        _isClick = YES;
        _chooseNoNum();
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
        _isClick = NO;
        _chooseYesNum();
    }
}

-(void)showData:(JGTeamAcitivtyModel *)model
{
    if (![Helper isBlankString:model.name]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    else
    {
        _nameLabel.text = [NSString stringWithFormat:@"暂无姓名"];
    }
    
    _moneyLabel.text = [NSString stringWithFormat:@"%@",model.money];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
