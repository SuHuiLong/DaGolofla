//
//  TeamApplyViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamApplyViewCell.h"

#import "UIImageView+WebCache.h"
#import "Helper.h"
#import "PostDataRequest.h"

#define kUserApply_URL @"aboutBallJoin/update.do"
#define kTeam_Url @"tTeamApply/update.do"

@implementation TeamApplyViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _dict = [[NSMutableDictionary alloc]init];
    _dictTeam = [[NSMutableDictionary alloc]init];
  
}
#pragma mark --球队的申请列表点击事件
//球队的申请列表点击事件
-(void)agreeJoinClick
{
    [_dictTeam setObject:@1 forKey:@"teamApplyState"];
    [_dictTeam setObject:@2 forKey:@"teamApplyId"];
    [_dictTeam setObject:@14 forKey:@"userIds"];
    [_dictTeam setObject:@1 forKey:@"userId"];
    [_dictTeam setObject:@1 forKey:@"type"];
    
    [[PostDataRequest sharedInstance] postDataRequest:kTeam_Url parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
            [_agreeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_disMissBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        }
        
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(void)disJoinClick
{
    [[PostDataRequest sharedInstance] postDataRequest:kTeam_Url parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_agreeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_disMissBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [_disMissBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
#pragma mark --约球的申请列表点击时间
-(void)agreeBtnClick
{
    [_dict setValue:@1 forKey:@"state"];
    //约球
    [_dict setValue:_ballId forKey:@"ballId"];
    
    NSString* str = [NSString stringWithFormat:@"%@同意了您的申请",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    [_dict setValue:str forKey:@"message"];
    [_dict setValue:_userId forKey:@"userId"];
    [_dict setObject:_userId forKey:@"uid"];
    [_dict setObject:@0 forKey:@"send"];
    [[PostDataRequest sharedInstance] postDataRequest:kUserApply_URL parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_agreeBtn setTitle:@"通过" forState:UIControlStateNormal];
            [_agreeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_disMissBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        }
        
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(void)disMissClick
{
    [_dict setValue:@2 forKey:@"state"];
    //约球
    [_dict setValue:_ballId forKey:@"ballId"];
    
    NSString* str = [NSString stringWithFormat:@"%@拒绝了您的申请",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    [_dict setValue:str forKey:@"message"];
    [_dict setValue:_userId forKey:@"userId"];
    [_dict setObject:_userId forKey:@"uid"];
    [_dict setObject:@0 forKey:@"send"];
    [[PostDataRequest sharedInstance] postDataRequest:kUserApply_URL parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_agreeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_disMissBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [_disMissBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showYueDetail:(YueDetailModel *)model
{
    
    [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_disMissBtn addTarget:self action:@selector(disMissClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_iconImage sd_setImageWithURL:[Helper imageUrl:model.pic] placeholderImage:[UIImage imageNamed:@"tx4"]];
    _nameLabel.text = model.userName;
    if ([model.sex integerValue] == 1) {
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
    }
    else
    {
        _sexImage.image = [UIImage imageNamed:@"xb_n"];
    }
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:model.birthday];
////    NSString* strAge = [[NSString alloc]init];
    
    _ageLabel.text = [NSString stringWithFormat:@"%@",model.age];
    _chadianLabel.text = [NSString stringWithFormat:@"差点 ：%@",model.almost];
}

-(void)showTeamJoin:(TeamJoinModel *)model
{
    
//    [_agreeBtn addTarget:self action:@selector(agreeJoinClick) forControlEvents:UIControlEventTouchUpInside];
//    [_disMissBtn addTarget:self action:@selector(disJoinClick) forControlEvents:UIControlEventTouchUpInside];
//    
    
    [_iconImage sd_setImageWithURL:[Helper imageUrl:model.pic] placeholderImage:[UIImage imageNamed:@"tx4"]];
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
    NSLog(@"%@",model.birthday);
    if (![Helper isBlankString:model.birthday]) {
        NSDate *date = [dateFormatter dateFromString:model.birthday];
        //    NSString* strAge = [[NSString alloc]init];
        _ageLabel.text = [NSString stringWithFormat:@"%ld",[self ageWithDateOfBirth:date]];
    }
    
    
    _chadianLabel.text = [NSString stringWithFormat:@"差点 ：%@",model.almost];
}

//转换时间
- (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}


@end
