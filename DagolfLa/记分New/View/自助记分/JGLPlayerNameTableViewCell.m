//
//  JGLPlayerNameTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPlayerNameTableViewCell.h"
#import "UITool.h"
@implementation JGLPlayerNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(63*ScreenWidth/375, 15*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        _labelName.text = @"闻醉山清风";
        _labelName.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_labelName];
        
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-110*ScreenWidth/375, 12.5*ScreenWidth/375, 25*ScreenWidth/375, 25*ScreenWidth/375)];
        _iconImgv.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_iconImgv];
        
        _labelTee = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-140*ScreenWidth/375, 15*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        _labelTee.text = @"蓝T";
        _labelTee.textAlignment = NSTextAlignmentRight;
        _labelTee.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_labelTee];
        
    }
    return self;
}

-(void)showTee:(NSString *)str{
    if ([str isEqualToString:@"红T"] == YES) {
        _iconImgv.backgroundColor = [UITool colorWithHexString:@"e21f23" alpha:1];
    }
    else if ([str isEqualToString:@"蓝T"] == YES)
    {
        _iconImgv.backgroundColor = [UITool colorWithHexString:@"2474ac" alpha:1];
    }
    else if ([str isEqualToString:@"黑T"] == YES)
    {
        _iconImgv.backgroundColor = [UITool colorWithHexString:@"000000" alpha:1];
    }
    else if ([str isEqualToString:@"黄T"] == YES || [str isEqualToString:@"金T"] == YES)
    {
        _iconImgv.backgroundColor = [UITool colorWithHexString:@"bedd00" alpha:1];
    }
    else
    {
        _iconImgv.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    }
    
    _labelTee.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
