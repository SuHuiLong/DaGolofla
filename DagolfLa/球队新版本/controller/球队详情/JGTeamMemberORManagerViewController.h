//
//  JGTeamMemberORManagerViewController.h
//  DagolfLa
//
//  Created by 東 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGTeamDetail.h"

@interface JGTeamMemberORManagerViewController : ViewController

@property (nonatomic, strong) JGTeamDetail *detailModel;
@property (nonatomic, strong) NSMutableDictionary *detailDic;
@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, assign) BOOL isManager;

@end
