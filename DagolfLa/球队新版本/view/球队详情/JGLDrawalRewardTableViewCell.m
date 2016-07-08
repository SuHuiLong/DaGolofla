//
//  JGLDrawalRewardTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLDrawalRewardTableViewCell.h"

@implementation JGLDrawalRewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/320, 10*screenWidth/320, 160*screenWidth/320, 20*screenWidth/320)];
        _labelName.font = [UIFont systemFontOfSize:15*screenWidth/320];
        [self addSubview:_labelName];
        
        _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(170*screenWidth/320, 10*screenWidth/320, 140*screenWidth/320, 20*screenWidth/320)];
        _labelTime.font = [UIFont systemFontOfSize:13*screenWidth/320];
        _labelTime.textColor = [UIColor lightGrayColor];
        _labelTime.textAlignment = NSTextAlignmentRight;
        [self addSubview:_labelTime];
        
//        
//        _labelAccept = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/320, 30*screenWidth/320, 160*screenWidth/320, 20*screenWidth/320)];
//        _labelAccept.font = [UIFont systemFontOfSize:15*screenWidth/320];
//        _labelAccept.textColor = [UIColor lightGrayColor];
//        [self addSubview:_labelAccept];
        
        _labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(170*screenWidth/320, 30*screenWidth/320, 140*screenWidth/320, 20*screenWidth/320)];
        _labelMoney.font = [UIFont systemFontOfSize:13*screenWidth/320];
        _labelMoney.textColor = [UIColor redColor];
        _labelMoney.textAlignment = NSTextAlignmentRight;
        [self addSubview:_labelMoney];
        
        
        _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/320, 50*screenWidth/320, screenWidth-20*screenWidth/320, 20*screenWidth/320)];
        [self addSubview:_labelDetail];
        
        
    }
    return self;
}


-(void)showData:(JGLDrawalRecordModel *)model
{
    //    cell.labelName.text   = @"提现人：罗小安";
    //    cell.labelAccept.text = @"收款人：罗大安";
    //    cell.labelTime.text   = @"2015年5月21日 09：55";
    //    cell.labelMoney.text  = @"1800元";
    //    cell.labelDetail.text = @"备注信息：这笔钱用于球场遇到过呢和啪啪啪。。。设呢";
    if (![Helper isBlankString:model.userName]) {
        _labelName.text = [NSString stringWithFormat:@"提现人：%@",model.userName];
    }
    else{
        _labelName.text = [NSString stringWithFormat:@"提现人：暂无提现人"];
    }
    
    
    if (![Helper isBlankString:model.exchangeTime]) {
        _labelTime.text = [NSString stringWithFormat:@"%@",model.exchangeTime];
    }
    else{
        _labelTime.text = [NSString stringWithFormat:@"暂无时间"];
    }
    
    _labelMoney.text = [NSString stringWithFormat:@"-%@元",model.amount];

    
    if (![Helper isBlankString:model.remark]) {
        _labelDetail.text = [NSString stringWithFormat:@"备注信息：%@",model.remark];
    }
    else{
        _labelDetail.text = [NSString stringWithFormat:@"备注信息：备注信息"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
