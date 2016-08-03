//
//  JGLScoreRankTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLScoreRankTableViewCell.h"

@implementation JGLScoreRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _labelRank = [[UILabel alloc]initWithFrame:CGRectMake(0*screenWidth/375, 10*screenWidth/375, 60*screenWidth/375, 24*screenWidth/375)];
        _labelRank.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelRank.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelRank];
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(60*screenWidth/375, 10*screenWidth/375, 105*screenWidth/375, 24*screenWidth/375)];
        _labelName.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelName];
        
        _labelAll = [[UILabel alloc]initWithFrame:CGRectMake(165*screenWidth/375, 10*screenWidth/375, 60*screenWidth/375, 24*screenWidth/375)];
        _labelAll.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelAll.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelAll];
        
        _labelAlmost = [[UILabel alloc]initWithFrame:CGRectMake(225*screenWidth/375, 10*screenWidth/375, 75*screenWidth/375, 24*screenWidth/375)];
        _labelAlmost.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelAlmost.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelAlmost];
        
        _labelTee = [[UILabel alloc]initWithFrame:CGRectMake(300*screenWidth/375, 10*screenWidth/375, 75*screenWidth/375, 24*screenWidth/375)];
        _labelTee.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelTee.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelTee];
        
        
    }
    return self;
}

-(void)showData:(JGLScoreRankModel *)model
{
//    _labelRank.text = model.userName;
    
    _labelName.text = [NSString stringWithFormat:@"%@",model.userName];
    
    _labelAll.text = [NSString stringWithFormat:@"%@",model.poleNumber];
    
    _labelAlmost.text = [NSString stringWithFormat:@"%@",model.netbar];
    
    _labelTee.text = [NSString stringWithFormat:@"%@",model.almost];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
