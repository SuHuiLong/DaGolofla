//
//  JGLTeamCounterMemberTableViewCell.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLTeamCounterMemberTableViewCell.h"

@implementation JGLTeamCounterMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8*screenWidth/320, 7*screenWidth/320, 40*screenWidth/320, 40*screenWidth/320)];
        [self addSubview:_iconImage];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(56*screenWidth/320, 5*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
        [self addSubview:_nameLabel];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:14*screenWidth/320];
        _nameLabel.text = @"豆芽菜";
        
        _sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(55*screenWidth/320, 38*screenWidth/320, 9*screenWidth/320, 12*screenWidth/320)];
        [self addSubview:_sexImage];
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
        
        
        _chadianLabel = [[UILabel alloc]initWithFrame:CGRectMake(70*screenWidth/320, 34*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
        _chadianLabel.font = [UIFont systemFontOfSize:10*screenWidth/320];
        _chadianLabel.textColor = [UIColor blackColor];
        [self addSubview:_chadianLabel];
        _chadianLabel.text = @"差点:39";
        
        _mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(130*screenWidth/320, 15*screenWidth/320, 130*screenWidth/320, 24*screenWidth/320)];
        _mobileLabel.font = [UIFont systemFontOfSize:13*screenWidth/320];
        _mobileLabel.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
        [self addSubview:_mobileLabel];
        _mobileLabel.textAlignment = NSTextAlignmentCenter;
        _mobileLabel.text = @"18612341234";
        
        _stateImgv = [[UIImageView alloc]initWithFrame:CGRectMake(261*screenWidth/320, 17*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
        _stateImgv.image = [UIImage imageNamed:@"btn_representative_add"];
        [self addSubview:_stateImgv];

        
        
    }
    return self;
}

-(void)showData:(JGLCompeteMemberModel *)model withUserKey:(NSNumber *)userKey
{
    [_iconImage sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.userName];
    
    if ([model.sex integerValue] == 0) {
        [_sexImage setImage: [UIImage imageNamed:@"xb_n"]];
    }
    else
    {
        [_sexImage setImage: [UIImage imageNamed:@"xb_nn"]];
    }
    
    _chadianLabel.text = [NSString stringWithFormat:@"差点：%@",model.almost];
    
    if (model.mobile.length == 11) {
        _mobileLabel.text = [NSString stringWithFormat:@"%@***%@",[model.mobile substringToIndex:3], [model.mobile substringFromIndex:8]];
    }else{
        if (![Helper isBlankString:model.mobile]) {
            _mobileLabel.text = [NSString stringWithFormat:@"%@***", model.mobile];
        }
        else{
            _mobileLabel.text = @"暂无手机号";
        }
    }
    if (userKey != nil) {
        if ([model.userKey integerValue] == [userKey integerValue]) {
            _stateImgv.image = [UIImage imageNamed:@"btn_myself_delete"];
        }
        else{
            if ([model.canMatch integerValue] == 0) {//0，参赛代表，1，不是参赛代表
                _stateImgv.image = [UIImage imageNamed:@"btn_representative"];
            }
            else{
                _stateImgv.image = [UIImage imageNamed:@""];
            }
        }
    }
    else{
        if ([model.canMatch integerValue] == 0) {//0，参赛代表，1，不是参赛代表
            _stateImgv.image = [UIImage imageNamed:@"btn_representative"];
        }
        else{
            _stateImgv.image = [UIImage imageNamed:@""];
        }
    }
    
}

-(void)showData:(JGLCompeteMemberModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.userName];
    
    if ([model.sex integerValue] == 0) {
        [_sexImage setImage: [UIImage imageNamed:@"xb_n"]];
    }
    else
    {
        [_sexImage setImage: [UIImage imageNamed:@"xb_nn"]];
    }
    
    _chadianLabel.text = [NSString stringWithFormat:@"差点：%@",model.almost];
    
    if (model.mobile.length == 11) {
        _mobileLabel.text = [NSString stringWithFormat:@"%@***%@",[model.mobile substringToIndex:3], [model.mobile substringFromIndex:8]];
    }else{
        if (![Helper isBlankString:model.mobile]) {
            _mobileLabel.text = [NSString stringWithFormat:@"%@***", model.mobile];
        }
        else{
            _mobileLabel.text = @"暂无手机号";
        }
    }
    if ([model.canMatch integerValue] == 0) {//0，参赛代表，1，不是参赛代表
        _stateImgv.image = [UIImage imageNamed:@"btn_representative"];
    }
    else{
        _stateImgv.image = [UIImage imageNamed:@""];
    }
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
