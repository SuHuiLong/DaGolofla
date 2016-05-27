//
//  JGNotTeamMemberDetailViewController.h
//  DagolfLa
//
//  Created by 東 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGTeamDetail.h"




/**
 *  显示申请加入则表明：非球队成员的球队详情界面
 */
@interface JGNotTeamMemberDetailViewController : ViewController

@property (nonatomic, strong) JGTeamDetail *detailModel;
@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, strong) NSDictionary *detailDic;

@end
