//
//  JGLScoreLiveDetailTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLScoreLiveDetailTableViewCell.h"
#import "UITool.h"
@implementation JGLScoreLiveDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 93*screenWidth/375, 22*screenWidth/375)];
        [self.contentView addSubview:_labelName];
        _labelName.textAlignment = NSTextAlignmentCenter;
        _labelName.font = [UIFont systemFontOfSize:13*screenWidth/375];
        
        _labelScoreName = [[UILabel alloc]initWithFrame:CGRectMake(0, 22*screenWidth/375, 93*screenWidth/375, 22*screenWidth/375)];
        [self.contentView addSubview:_labelScoreName];
        _labelScoreName.textAlignment = NSTextAlignmentCenter;
        _labelScoreName.textColor = [UITool colorWithHexString:@"32b14d" alpha:1];
        _labelScoreName.font = [UIFont systemFontOfSize:13*screenWidth/375];
        
        _labelFinish = [[UILabel alloc]initWithFrame:CGRectMake(94*screenWidth/375, 0, 93*screenWidth/375, 44*screenWidth/375)];
        [self.contentView addSubview:_labelFinish];
        _labelFinish.textAlignment = NSTextAlignmentCenter;
        _labelFinish.font = [UIFont systemFontOfSize:13*screenWidth/375];
        
        _labelPole = [[UILabel alloc]initWithFrame:CGRectMake(187*screenWidth/375, 0, 93*screenWidth/375, 44*screenWidth/375)];
        [self.contentView addSubview:_labelPole];
        _labelPole.textAlignment = NSTextAlignmentCenter;
        _labelPole.font = [UIFont systemFontOfSize:13*screenWidth/375];
        
        
        _labelAlmost = [[UILabel alloc]initWithFrame:CGRectMake(282*screenWidth/375, 0, 93*screenWidth/375, 44*screenWidth/375)];
        [self.contentView addSubview:_labelAlmost];
        _labelAlmost.textAlignment = NSTextAlignmentCenter;
        _labelAlmost.font = [UIFont systemFontOfSize:13*screenWidth/375];
        
        for (int i = 0; i < 3; i++) {
            _viewCut = [[UIView alloc]initWithFrame:CGRectMake(93*screenWidth/375 + 93*screenWidth/375*i, 0, 1*screenWidth/375, 44*screenWidth/375)];
            _viewCut.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:_viewCut];
        }
        
    }
    return self;
}

-(void)showData:(JGLScoreLiveModel *)model
{
    _labelName.text = model.userName;
    
    _labelScoreName.text = [NSString stringWithFormat:@"记分人：%@",model.scoreUserName];
    
    _labelFinish.text = [NSString stringWithFormat:@"%@/18",model.tunnelNumber];
    
    _labelPole.text = [NSString stringWithFormat:@"%@",model.poleNumber];
    
    _labelAlmost.text = [NSString stringWithFormat:@"%@",model.poorBar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
