//
//  FabuYueBallViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/17.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "FabuYueBallViewCell.h"
#import "TeamMessageController.h"

@implementation FabuYueBallViewCell

- (void)awakeFromNib {
    [_xuanBtn addTarget:self action:@selector(chooseClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)chooseClick
{
    if (_choose == NO) {
        _choose = YES;
        
        if (_strlegth <= 0) {
            _choose = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有选择通讯录好友" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
                [_xuanBtn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
                TeamMessageController* team = [[TeamMessageController alloc]init];

                team.dataArray = _dataArray;
                team.telArray = _telArray;

            _block(team);   
        }
    }
    else
    {
        _choose = NO;
        [_xuanBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
