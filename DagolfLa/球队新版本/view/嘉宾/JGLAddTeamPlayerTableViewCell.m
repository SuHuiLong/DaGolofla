//
//  JGLAddTeamPlayerTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddTeamPlayerTableViewCell.h"
#import "UITool.h"
@implementation JGLAddTeamPlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(5*screenWidth/375, 5*screenWidth/375, 40*screenWidth/375, 40*screenWidth/375)];
        [self addSubview:_iconImgv];
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.layer.cornerRadius = 40*screenWidth/375/2;
        [_iconImgv setImage:[UIImage imageNamed:DefaultHeaderImage]];//moren
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*screenWidth/375, 5*screenWidth/375, 200*screenWidth/375, 20*screenWidth/375)];
        _nameLabel.text = @"没什么特长就名字特长";
        _nameLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor blackColor];
        
        
        _sexImgv = [[UIImageView alloc]initWithFrame:CGRectMake(60*screenWidth/375, 30*screenWidth/375, 12*screenWidth/375, 16*screenWidth/375)];
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
        [self addSubview:_sexImgv];
        
        _almostLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*screenWidth/375, 30*screenWidth/375, 80*screenWidth/375, 20*screenWidth/375)];
        _almostLabel.textColor = [UIColor blackColor];
        _almostLabel.text = @"差点 39";
        [self addSubview:_almostLabel];
        _almostLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        
        _mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(160*screenWidth/375, 30*screenWidth/375, 140*screenWidth/375, 20*screenWidth/375)];
        _mobileLabel.textColor = [UITool colorWithHexString:@"7fc1ff" alpha:1];
        [self addSubview:_mobileLabel];
        _mobileLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        _stateImgv = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth - 60)*screenWidth/375, 15*screenWidth/375, 20*screenWidth/375, 20*screenWidth/375)];
        [self addSubview:_stateImgv];
    }
    return self;
}

-(void)showData:(JGLTeamMemberModel *)model
{
    [_iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.userName];
    
    if ([model.sex integerValue] == 0) {
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
    }
    else
    {
        [_sexImgv setImage: [UIImage imageNamed:@"xb_nn"]];
    }
    
    if ([model.almost floatValue] == -10000) {
        _almostLabel.text = @"差点  --";
    }else{
        [NSString stringWithFormat:@"差点  %@", (model.almost)?model.almost:@"--"];
    }
    
    if (model.mobile.length == 11) {
        _mobileLabel.text = [NSString stringWithFormat:@"%@***%@",[model.mobile substringToIndex:3], [model.mobile substringFromIndex:8]];
    }else{
        _mobileLabel.text = [NSString stringWithFormat:@"%@***", model.mobile];
    }
    
    
}

@end
