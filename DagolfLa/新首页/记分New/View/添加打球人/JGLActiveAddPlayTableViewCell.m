
//
//  JGLActiveAddPlayTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActiveAddPlayTableViewCell.h"
#import "JGLAddActiivePlayModel.h"

@implementation JGLActiveAddPlayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgvState = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 15*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375)];
        _imgvState.image = [UIImage imageNamed:@"gou_w"];
        [self addSubview:_imgvState];
        
        _imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(40*ScreenWidth/375, 5*ScreenWidth/375, 40*ScreenWidth/375, 40*ScreenWidth/375)];
        _imgvIcon.image = [UIImage imageNamed:TeamLogoImage];
        [self addSubview:_imgvIcon];
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(100*ScreenWidth/375, 5*ScreenWidth/375, 100*ScreenWidth/375, 40*ScreenWidth/375)];
        _labelName.text = @"闻醉山清风";
        _labelName.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self addSubview:_labelName];
        
//        _labelMobiel = [[UILabel alloc]initWithFrame:CGRectMake(170*ScreenWidth/375, 10*ScreenWidth/375, 120*ScreenWidth/375, 40*ScreenWidth/375)];
//        _labelMobiel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
//        [self addSubview:_labelMobiel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGLAddActiivePlayModel:(JGLAddActiivePlayModel *)model{
    
    _labelName.text = model.name;
    [_imgvIcon sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    _imgvIcon.layer.cornerRadius = 6*screenWidth/375;
    _imgvIcon.layer.masksToBounds = YES;
    
    if (model.select == 1) {
        _imgvState.image=[UIImage imageNamed:@"gou_x"];
    }else{
        _imgvState.image=[UIImage imageNamed:@"gou_w"];
    }

}

@end
