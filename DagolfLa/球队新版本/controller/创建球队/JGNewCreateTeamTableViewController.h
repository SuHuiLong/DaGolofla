//
//  JGNewCreateTeamTableViewController.h
//  DagolfLa
//
//  Created by 東 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGTeamDetail.h"

@interface JGNewCreateTeamTableViewController : ViewController

@property (nonatomic, strong) JGTeamDetail *detailModel;
@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, strong)UIButton *headPortraitBtn;//头像
@property (nonatomic, strong)UITextField *titleField;//球队名称输入框
@property (nonatomic, strong) NSMutableDictionary *detailDic;


@end
