//
//  JGLAddTeaPlayerViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/9/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLTeamMemberModel.h"
@interface JGLAddTeaPlayerViewController : ViewController

@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (copy, nonatomic) void (^blockTMemberPeople)(NSMutableDictionary*);//嘉宾的回调方法

@end
