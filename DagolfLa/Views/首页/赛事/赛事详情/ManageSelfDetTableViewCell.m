//
//  ManageSelfDetTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/1/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ManageSelfDetTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"

#import "PostDataRequest.h"

@implementation ManageSelfDetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 7*ScreenWidth/375, 40*ScreenWidth/375, 40*ScreenWidth/375)];
        [self.contentView addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(56*ScreenWidth/375, 5*ScreenWidth/375, 200*ScreenWidth/375, 20*ScreenWidth/375)];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        _sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(59*ScreenWidth/375, 38*ScreenWidth/375, 9*ScreenWidth/375, 12*ScreenWidth/375)];
        [self.contentView addSubview:_sexImage];
        
        _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(74*ScreenWidth/375, 34*ScreenWidth/375, 60*ScreenWidth/375, 20*ScreenWidth/375)];
        _ageLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _ageLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_ageLabel];
        
        _chadianLabel = [[UILabel alloc]initWithFrame:CGRectMake(142*ScreenWidth/375, 34*ScreenWidth/375, 117*ScreenWidth/375, 20*ScreenWidth/375)];
        _chadianLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _chadianLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_chadianLabel];
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.frame = CGRectMake(267*ScreenWidth/375, 15*ScreenWidth/375, 46*ScreenWidth/375, 25*ScreenWidth/375);
        [self.contentView addSubview:_agreeBtn];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        _disMissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _disMissBtn.frame = CGRectMake(321*ScreenWidth/375, 15*ScreenWidth/375, 46*ScreenWidth/375, 25*ScreenWidth/375);
        [self.contentView addSubview:_disMissBtn];
        [_disMissBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_disMissBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _disMissBtn.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
    }
    return self;
}
#pragma mark --悬赏的申请列表点击时间
-(void)agreeBtnClick
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@1 forKey:@"teamApplyState"];
    
    [dict setValue:_ballId forKey:@"teamApplyId"];
    
    NSString* str = [NSString stringWithFormat:@"%@同意了您的申请",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    [dict setValue:str forKey:@"NoticeString"];
    [dict setValue:@0 forKey:@"userIds"];
    [dict setObject:_userId forKey:@"userId"];
    [dict setObject:@12 forKey:@"type"];
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/update.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success" ] integerValue] == 1) {
            
            [_agreeBtn setTitle:@"通过" forState:UIControlStateNormal];
            [_agreeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_disMissBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _callBackData();
        }
        
    } failed:^(NSError *error) {
    }];
    
}

-(void)disMissClick
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@2 forKey:@"teamApplyState"];
    
    [dict setValue:_ballId forKey:@"teamApplyId"];
    
    NSString* str = [NSString stringWithFormat:@"%@拒绝了您的申请",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    [dict setValue:str forKey:@"NoticeString"];
    [dict setValue:@0 forKey:@"userIds"];
    [dict setObject:_userId forKey:@"userId"];
    [dict setObject:@12 forKey:@"type"];
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/update.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success" ] integerValue] == 1) {
            
            [_agreeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_disMissBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [_disMissBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _callBackData();
        }
        
    } failed:^(NSError *error) {
    }];
}
-(void)showManDetail:(ManageApplyModel *)model
{
    
    _userId = model.userId;
    _ballId = model.teamApplyId;
    [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_disMissBtn addTarget:self action:@selector(disMissClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    _nameLabel.text = model.userName;
    if ([model.sex integerValue] == 1) {
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
    }
    else
    {
        _sexImage.image = [UIImage imageNamed:@"xb_n"];
    }
    
    _ageLabel.text = [NSString stringWithFormat:@"%@",model.age];
    _chadianLabel.text = [NSString stringWithFormat:@"差点 ：%@",model.almost];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
