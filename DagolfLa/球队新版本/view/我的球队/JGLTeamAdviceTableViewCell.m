//
//  JGLTeamAdviceTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLTeamAdviceTableViewCell.h"

@implementation JGLTeamAdviceTableViewCell

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
        
        _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(160*screenWidth/320, 5*screenWidth/320, 60*screenWidth/320, 20*screenWidth/320)];
        [self addSubview:_ageLabel];
        _ageLabel.textAlignment = NSTextAlignmentLeft;
        _ageLabel.font = [UIFont systemFontOfSize:13*screenWidth/320];
        _ageLabel.text = @"24年";
        _sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(59*screenWidth/320, 38*screenWidth/320, 9*screenWidth/320, 12*screenWidth/320)];
        [self addSubview:_sexImage];
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
        
        
        _chadianLabel = [[UILabel alloc]initWithFrame:CGRectMake(74*screenWidth/320, 34*screenWidth/320, 60*screenWidth/320, 20*screenWidth/320)];
        _chadianLabel.font = [UIFont systemFontOfSize:13*screenWidth/320];
        _chadianLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_chadianLabel];
        _chadianLabel.text = @"差点:39";
        
        _mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(140*screenWidth/320, 34*screenWidth/320, 130*screenWidth/320, 20*screenWidth/320)];
        _mobileLabel.font = [UIFont systemFontOfSize:13*screenWidth/320];
        _mobileLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_mobileLabel];
        _mobileLabel.text = @"手机号:18612341234";
        
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.frame = CGRectMake(227*screenWidth/320, 15*screenWidth/320, 46*screenWidth/320, 25*screenWidth/320);
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
//        _agreeBtn.titleLabel.textColor = [UIColor orangeColor];
        [_agreeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:_agreeBtn];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _disMissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _disMissBtn.frame = CGRectMake(271*screenWidth/320, 15*screenWidth/320, 46*screenWidth/320, 25*screenWidth/320);
        [_disMissBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_disMissBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _disMissBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_disMissBtn];
    }
    return self;
}

//-(void)agree1Click
//{
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:@181 forKey:@"teamKey"];
//    [dict setObject:@244 forKey:@"userKey"];
//    [dict setObject:@184 forKey:@"memberKey"];
//    [dict setObject:@1 forKey:@"state"];
//    [[JsonHttp jsonHttp]httpRequest:@"team/auditTeamMember" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
//
//    } completionBlock:^(id data) {
//        NSLog(@"%@",[data objectForKey:@"packResultMsg"]);
//    }];
//}
//-(void)dis1Click
//{
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:@181 forKey:@"teamKey"];
//    [dict setObject:@244 forKey:@"userKey"];
//    [dict setObject:@184 forKey:@"memberKey"];
//    [dict setObject:@2 forKey:@"state"];
//    [[JsonHttp jsonHttp]httpRequest:@"team/auditTeamMember" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
//
//    } completionBlock:^(id data) {
//        NSLog(@"%@",[data objectForKey:@"packResultMsg"]);
//    }];
//}

-(void)showData:(JGLTeamMemberModel *)model
{
//    [_agreeBtn addTarget:self action:@selector(agree1Click) forControlEvents:UIControlEventTouchUpInside];
//    [_disMissBtn addTarget:self action:@selector(dis1Click) forControlEvents:UIControlEventTouchUpInside];


    [_iconImage sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO]];
    _nameLabel.text = model.userName;
    _ageLabel.text = [NSString stringWithFormat:@"%@岁",model.ballage];
    if ([model.sex integerValue] == 1) {
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
    }
    else
    {
        _sexImage.image = [UIImage imageNamed:@"xb_n"];
    }
    _chadianLabel.text = [NSString stringWithFormat:@"差点:%@",model.almost];
    _mobileLabel.text = [NSString stringWithFormat:@"手机号:%@",model.mobile];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
