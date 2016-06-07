//
//  JGTeamCreatePhotoController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGTeamCreatePhotoController : ViewController

/**
 *  判断是相册创建还是相册管理
 */
@property (assign, nonatomic) BOOL isManage;
//球队的timekey，创建，修改都要用到
@property (strong, nonatomic) NSNumber* teamKey;
//球队相册的timekey，修改相册需要
@property (strong, nonatomic) NSNumber* timeKey;

//创建相册的block
@property (copy, nonatomic) void(^createBlock)();
@end
