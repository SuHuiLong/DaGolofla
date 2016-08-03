//
//  JGLScoreLiveHeadTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLScoreLiveHeadTableViewCell.h"
#import "UITool.h"
@implementation JGLScoreLiveHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 2*screenWidth/375)];
        _viewLine.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
        [self.contentView addSubview:_viewLine];
        
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 2*screenWidth/375, 93*screenWidth/375, 42*screenWidth/375)];
        [self.contentView addSubview:_labelName];
        _labelName.textAlignment = NSTextAlignmentCenter;
        _labelName.text = @"球队成员";
        _labelName.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelName.textColor = [UITool colorWithHexString:@"23512d" alpha:1];
        
        _labelFinish = [[UILabel alloc]initWithFrame:CGRectMake(94*screenWidth/375, 2*screenWidth/375, 93*screenWidth/375, 42*screenWidth/375)];
        [self.contentView addSubview:_labelFinish];
        _labelFinish.textAlignment = NSTextAlignmentCenter;
        _labelFinish.text = @"完成/洞数";
        _labelFinish.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelFinish.textColor = [UITool colorWithHexString:@"23512d" alpha:1];
        
        _labelPole = [[UILabel alloc]initWithFrame:CGRectMake(187*screenWidth/375, 2*screenWidth/375, 93*screenWidth/375, 42*screenWidth/375)];
        [self.contentView addSubview:_labelPole];
        _labelPole.textAlignment = NSTextAlignmentCenter;
        _labelPole.text = @"杆数";
        _labelPole.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelPole.textColor = [UITool colorWithHexString:@"23512d" alpha:1];
        
        _labelAlmost = [[UILabel alloc]initWithFrame:CGRectMake(282*screenWidth/375, 2*screenWidth/375, 93*screenWidth/375, 42*screenWidth/375)];
        [self.contentView addSubview:_labelAlmost];
        _labelAlmost.textAlignment = NSTextAlignmentCenter;
        _labelAlmost.text = @"差杆";
        _labelAlmost.font = [UIFont systemFontOfSize:13*screenWidth/375];
        _labelAlmost.textColor = [UITool colorWithHexString:@"23512d" alpha:1];
        
        for (int i = 0; i < 3; i++) {
            _viewCut = [[UIView alloc]initWithFrame:CGRectMake(93*screenWidth/375 + 93*screenWidth/375*i, 0, 1*screenWidth/375, 44*screenWidth/375)];
            _viewCut.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:_viewCut];
        }
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
