//
//  JGHNewMenberTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewMenberTableViewCell.h"
#import "JGLTeamMemberModel.h"

@implementation JGHNewMenberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
        _nameLabel.text = @"";
        _nameLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor blackColor];
        
        
        _sexImgv = [[UIImageView alloc]initWithFrame:CGRectMake(60*screenWidth/375, 30*screenWidth/375, 12*screenWidth/375, 16*screenWidth/375)];
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
        [self addSubview:_sexImgv];
        
        _almostLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*screenWidth/375, 30*screenWidth/375, 80*screenWidth/375, 20*screenWidth/375)];
        _almostLabel.textColor = [UIColor blackColor];
        _almostLabel.text = @"差点  ";
        [self addSubview:_almostLabel];
        _almostLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        
        _poleLabel = [[UILabel alloc]initWithFrame:CGRectMake(160*screenWidth/375, 30*screenWidth/375, 130*screenWidth/375, 20*screenWidth/375)];
        _poleLabel.textColor = [UIColor blackColor];
        _poleLabel.text = @"平均杆数 102杆";
        [self addSubview:_poleLabel];
        _poleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        _selectImgv = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth - 45)*screenWidth/375, 17*screenWidth/375, 15*screenWidth/375, 15*screenWidth/375)];
//        [_selectImgv setImage: [UIImage imageNamed:@"duihao"]];
        [self addSubview:_selectImgv];
    }
    return self;
}

- (void)showIntentionData:(JGLTeamMemberModel *)model{
    [_iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.userName];
    
    if ([model.sex integerValue] == 0) {
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
    }
    else
    {
        [_sexImgv setImage: [UIImage imageNamed:@"xb_nn"]];
    }
    
    _almostLabel.text = [NSString stringWithFormat:@"差点  %.1f",[model.almost floatValue]];
    
    //显示模式XXX。。。XXX
    if (model.mobile) {
        _poleLabel.text = [NSString stringWithFormat:@"%@", model.mobile];
    }
    
    _selectImgv.image = nil;
    if (model.select == 1) {
        [_selectImgv setImage: [UIImage imageNamed:@"duihao"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
