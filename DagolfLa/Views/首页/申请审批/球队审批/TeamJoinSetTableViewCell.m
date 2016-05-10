//
//  TeamJoinSetTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/1/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "TeamJoinSetTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "PostDataRequest.h"

@implementation TeamJoinSetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _dict = [[NSMutableDictionary alloc]init];
    _dictTeam = [[NSMutableDictionary alloc]init];
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 7*ScreenWidth/375, 40*ScreenWidth/375, 40*ScreenWidth/375)];
        [self addSubview:_iconImage];
        
        _sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(59*ScreenWidth/375, 38*ScreenWidth/375, 9*ScreenWidth/375, 12*ScreenWidth/375)];
        [self addSubview:_sexImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(56*ScreenWidth/375, 5*ScreenWidth/375, 200*ScreenWidth/375, 20*ScreenWidth/375)];
        _nameLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        
        _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(74*ScreenWidth/375, 34*ScreenWidth/375, 60*ScreenWidth/375, 20*ScreenWidth/375)];
        _ageLabel.textColor = [UIColor lightGrayColor];
        _ageLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
        _ageLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_ageLabel];
        
        _chadianLabel = [[UILabel alloc]initWithFrame:CGRectMake(142*ScreenWidth/375, 34*ScreenWidth/375, 117*ScreenWidth/375, 20*ScreenWidth/375)];
        _chadianLabel.textColor = [UIColor lightGrayColor];
        _chadianLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
        _chadianLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_chadianLabel];
        
        
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.frame = CGRectMake(257*ScreenWidth/375, 0*ScreenWidth/375, 46*ScreenWidth/375, 40*ScreenWidth/375);
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:_agreeBtn];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        _disMissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _disMissBtn.frame = CGRectMake(321*ScreenWidth/375, 0*ScreenWidth/375, 46*ScreenWidth/375, 40*ScreenWidth/375);
        [_disMissBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_disMissBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:_disMissBtn];
        _disMissBtn.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        
        _btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDetail.frame = CGRectMake(200*ScreenWidth/375, 0*ScreenWidth/375, 46*ScreenWidth/375, 40*ScreenWidth/375);
        [_btnDetail setImage:[UIImage imageNamed:@"xinfeng"] forState:UIControlStateNormal];
        [_btnDetail setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:_btnDetail];
        _btnDetail.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        
    }
    return self;
}

#pragma mark --球队的申请列表点击事件
//球队的申请列表点击事件
-(void)agreeJoinClick
{
    _dictTeam = [[NSMutableDictionary alloc]init];
    [_dictTeam setObject:@1 forKey:@"teamApplyState"];
    [_dictTeam setObject:_teamApplyId forKey:@"teamApplyId"];
    [_dictTeam setObject:@0 forKey:@"userIds"];
    [_dictTeam setObject:_userAcceptId forKey:@"userId"];
    [_dictTeam setObject:@10 forKey:@"type"];
    [_dictTeam setObject:[NSString stringWithFormat:@"%@同意了您加入球队的申请",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"NoticeString"];
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/update.do" parameter:_dictTeam success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
            [_disMissBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [_agreeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_disMissBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        }
        
    } failed:^(NSError *error) {
    }];
    
}
-(void)disJoinClick
{
    
    _dictTeam = [[NSMutableDictionary alloc]init];
    [_dictTeam setObject:@2 forKey:@"teamApplyState"];
    [_dictTeam setObject:_teamApplyId forKey:@"teamApplyId"];
    [_dictTeam setObject:@0 forKey:@"userIds"];
    [_dictTeam setObject:_userAcceptId forKey:@"userId"];
    [_dictTeam setObject:@10 forKey:@"type"];
    [_dictTeam setObject:[NSString stringWithFormat:@"%@拒绝了您加入球队的申请",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"NoticeString"];
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/update.do" parameter:_dictTeam success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_agreeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
            [_disMissBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [_disMissBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
    }];
    
}

-(void)showTeamJoin:(TeamJoinModel *)model
{
    _strDetails = model.applyContext;
    
    _strCom = model.applyContext;
    
    _userAcceptId = model.userId;
    _teamApplyId = model.teamApplyId;
    [_agreeBtn addTarget:self action:@selector(agreeJoinClick) forControlEvents:UIControlEventTouchUpInside];
    [_disMissBtn addTarget:self action:@selector(disJoinClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnDetail addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    
    if (![Helper isBlankString:model.userName]) {
        _nameLabel.text = model.userName;
    }
    
    if ([model.sex integerValue] == 1) {
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
    }
    else
    {
        _sexImage.image = [UIImage imageNamed:@"xb_n"];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    ////NSLog(@"%@",model.birthday);
    _ageLabel.text = [NSString stringWithFormat:@"%@",model.age];

    
    
    _chadianLabel.text = [NSString stringWithFormat:@"差点 ：%@",model.almost];
}


-(void)detailClick
{
    
    CustomIOSAlertView * alertView = [[CustomIOSAlertView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"朕知道了",nil]];//添加按钮
    //[alertView setDelegate:self];
    alertView.delegate = self;
    [alertView setContainerView:[self createDetailView]];
    [alertView show];
    [_btnDetail setImage:[UIImage imageNamed:@"kai"] forState:UIControlStateNormal];
}
#pragma mark --自定义UIalert
//自定义alert视图
- (UIView *)createDetailView
{
    
    CGFloat heidgt = [Helper textHeightFromTextString:_strCom width:255*ScreenWidth/375 fontSize:16*ScreenWidth/375];
    if (heidgt < 100) {
        heidgt = 100;
    }
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255*ScreenWidth/375, heidgt)];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 255*ScreenWidth/375, 150*ScreenWidth/375)];
    if (![Helper isBlankString:_strCom]) {
        label.text = _strCom;
    }
    else{
        _btnDetail.hidden = YES;
        
    }
    [detailView addSubview:label];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    return detailView;
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
   [_btnDetail setImage:[UIImage imageNamed:@"xinfeng"] forState:UIControlStateNormal];
    [alertView close];
}
@end
