//
//  JGLPayListTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPayListTableViewCell.h"
#import "UITool.h"
@implementation JGLPayListTableViewCell
{
    BOOL _isClick;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _isClick = NO;
    
    [_stateBtn addTarget:self action:@selector(stateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    _nameLabel.font  = [UIFont systemFontOfSize:13*ScreenWidth/320];
    
    [_payBtn setTitleColor:[UITool colorWithHexString:@"#e00000" alpha:1] forState:UIControlStateNormal];
    [_payBtn.layer setBorderWidth:1.0]; //边框宽度
    _payBtn.layer.borderColor = [[UITool colorWithHexString:@"#e00000" alpha:1] CGColor];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:13*screenWidth/375];
    _payBtn.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius = 8*screenWidth/320;
    
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
    
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.money];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
