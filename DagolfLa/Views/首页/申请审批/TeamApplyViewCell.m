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
         
            _callBackData();
        }
        
    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
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
            _callBackData();
        }
    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
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
    
    
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    _nameLabel.text = model.userName;
    if ([model.sex integerValue] == 1) {
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
    }
    else
    {
        _sexImage.image = [UIImage imageNamed:@"xb_n"];
    }
    if (model.age != nil) {
        _ageLabel.text = [NSString stringWithFormat:@"%@",model.age];
    }
    else
    {
        _ageLabel.text = [NSString stringWithFormat:@"0"];
    }
    _chadianLabel.text = [NSString stringWithFormat:@"差点 ：%@",model.almost];
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
//
//-(void)showManage:(JGLTeamMemberModel *)model
//{
//    [_agreeBtn addTarget:self action:@selector(agree1Click) forControlEvents:UIControlEventTouchUpInside];
//    [_disMissBtn addTarget:self action:@selector(dis1Click) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    _nameLabel.text = model.userName;
//    if ([model.sex integerValue] == 1) {
//        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
//    }
//    else
//    {
//        _sexImage.image = [UIImage imageNamed:@"xb_n"];
//    }
//   
//    _ageLabel.text = [NSString stringWithFormat:@"差点 ：%@",model.almost];
//
//    _chadianLabel.text = [NSString stringWithFormat:@"手机号 ：%@",model.mobile];
//}


@end
