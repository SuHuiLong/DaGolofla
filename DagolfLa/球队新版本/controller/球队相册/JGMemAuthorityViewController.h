//
//  JGMemAuthorityViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLTeamMemberModel.h"

/**
 *  球队成员的权限设置
 */

@interface JGMemAuthorityViewController : ViewController


@property (strong, nonatomic) NSNumber* teamKey;
@property (strong, nonatomic) NSNumber* memberKey;

@property (strong, nonatomic) NSMutableDictionary* dictAccount;

@property (strong, nonatomic) JGLTeamMemberModel* model;


@end
