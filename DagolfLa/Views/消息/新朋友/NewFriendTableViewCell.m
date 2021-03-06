//
//  NewFriendTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/3/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "NewFriendTableViewCell.h"
@implementation NewFriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.userInteractionEnabled = YES;
        
        [self createView];
    }
    return self;
}

-(void)createView
{
    _btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnIcon.frame = CGRectMake(10*ScreenWidth/375, 8.5*ScreenWidth/375, 50*ScreenWidth/375, 50*ScreenWidth/375);
    [_btnIcon setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
    _btnIcon.layer.cornerRadius = 25*ScreenWidth/375;
    _btnIcon.layer.masksToBounds = YES;
//    _btnIcon.contentMode = UIViewContentModeScaleAspectFill;
    [[_btnIcon imageView] setContentMode:UIViewContentModeScaleAspectFill];
    

    [self addSubview:_btnIcon];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 7*ScreenWidth/375, 200*ScreenWidth/375, 20*ScreenWidth/375)];
    _nameLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _nameLabel.text = @"溪中小鱼";
    [self addSubview:_nameLabel];
    
    _imgvSex = [[UIImageView alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 31*ScreenWidth/375, 12*ScreenWidth/375, 12*ScreenWidth/375)];
    _imgvSex.image = [UIImage imageNamed:@"xb_n"];
    [self addSubview:_imgvSex];
    
    _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*ScreenWidth/375, 26*ScreenWidth/375, 180*ScreenWidth/375, 20*ScreenWidth/375)];
    _ageLabel.font = [UIFont systemFontOfSize:12*ScreenWidth/375];
    _ageLabel.text = @"18";
    [self addSubview:_ageLabel];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 44*ScreenWidth/375, 220*ScreenWidth/375, 20*ScreenWidth/375)];
    _detailLabel.font = [UIFont systemFontOfSize:12*ScreenWidth/375];
    _detailLabel.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
//    _detailLabel.text = @"我需要三件东西。。";
    [self addSubview:_detailLabel];
    
    _btnFocus = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnFocus setTitle:@"添加" forState:UIControlStateNormal];
    _btnFocus.backgroundColor = [UIColor colorWithHexString:Bar_Color];
    _btnFocus.frame = CGRectMake(ScreenWidth-65*ScreenWidth/375, 18*ScreenWidth/375, 55*ScreenWidth/375, 30*ScreenWidth/375);
    _btnFocus.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_btnFocus.layer setMasksToBounds:YES];
    [_btnFocus.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_btnFocus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    [self addSubview:_btnFocus];

}


// 球友推荐
-(void)showData:(NewFriendModel *)model
{
    [_btnIcon sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.friendKey integerValue] andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    
    if (![Helper isBlankString:model.userName]) {
        _nameLabel.text = model.userName;
    }
    else
    {
        _nameLabel.text = @"暂无用户名";
    }
    if ([model.sex integerValue] == 0) {
        _imgvSex.image = [UIImage imageNamed:@"xb_n"];
    }
    else
    {
        _imgvSex.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    if (model.workName) {
        
        if (model.almost) {
            if ([model.almost floatValue] == -10000) {
                _ageLabel.text = [NSString stringWithFormat:@"－－  |  %@", model.workName];
            }else{
                _ageLabel.text = [NSString stringWithFormat:@"%@  |  %@", model.almost, model.workName];
            }
        }else{
            _ageLabel.text = [NSString stringWithFormat:@"－－  |  %@", model.workName];
        }

    }else{
        
        if (model.almost) {
            if ([model.almost floatValue] == -10000) {
                _ageLabel.text = @"差点  --";
            }else{
                _ageLabel.text = [NSString stringWithFormat:@"%@", model.almost];
            }
        }else{
            _ageLabel.text = @"差点  --";
        }

    }
//    _ageLabel.text = [NSString stringWithFormat:@"%@",model.age];
    
    if (![Helper isBlankString:model.reason]) {
        _detailLabel.text = [NSString stringWithFormat:@"推荐理由:%@", model.reason];
    }
    
    if ([model.state integerValue] == 3) {
        _btnFocus.frame = CGRectMake(ScreenWidth-75*ScreenWidth/375, 18*ScreenWidth/375, 65*ScreenWidth/375, 30*ScreenWidth/375);
        [_btnFocus setTitle:@"等待验证" forState:UIControlStateNormal];
        [_btnFocus setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        _btnFocus.backgroundColor = [UIColor clearColor];
        _btnFocus.enabled = NO;
    }else{
        _btnFocus.frame = CGRectMake(ScreenWidth-65*ScreenWidth/375, 18*ScreenWidth/375, 55*ScreenWidth/375, 30*ScreenWidth/375);
        [_btnFocus setTitle:@"添加" forState:UIControlStateNormal];
        _btnFocus.backgroundColor = [UIColor colorWithHexString:Bar_Color];
        [_btnFocus setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnFocus.enabled = YES;

    }
    
}

// 新朋友
-(void)exhibitionData:(NewFriendModel *)model
{
    [_btnIcon sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.friendUserKey integerValue] andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    
    if (![Helper isBlankString:model.userName]) {
        _nameLabel.text = model.userName;
    }
    else
    {
        _nameLabel.text = @"暂无用户名";
    }
    if ([model.sex integerValue] == 0) {
        _imgvSex.image = [UIImage imageNamed:@"xb_n"];
    }
    else
    {
        _imgvSex.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    if (model.workName) {
        
        if (model.almost) {
            if ([model.almost floatValue] == -10000) {
                _ageLabel.text = [NSString stringWithFormat:@"－－  |  %@", model.workName];
            }else{
                _ageLabel.text = [NSString stringWithFormat:@"%@  |  %@", model.almost, model.workName];
            }
        }else{
            _ageLabel.text = [NSString stringWithFormat:@"－－  |  %@", model.workName];
        }
        
    }else{
        
        if (model.almost) {
            if ([model.almost floatValue] == -10000) {
                _ageLabel.text = @"差点  --";
            }else{
                _ageLabel.text = [NSString stringWithFormat:@"%@", model.almost];
            }
        }else{
            _ageLabel.text = @"差点  --";
        }
        
    }
    
    if (![Helper isBlankString:model.reason]) {
        _detailLabel.text = model.reason;
    }

    if ([model.state integerValue] == 0) {
        [_btnFocus setTitle:@"接受" forState:UIControlStateNormal];
    }else{
        [_btnFocus setTitle:@"已添加" forState:UIControlStateNormal];
        [_btnFocus setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        _btnFocus.backgroundColor = [UIColor clearColor];
        _btnFocus.enabled = NO;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
