//
//  ActivityDetailViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"
@interface ActivityDetailViewController : BaseViewController
//活动id
@property (nonatomic,copy) NSString *activityKey;
//球队id
@property (nonatomic,copy) NSNumber *teamId;
@end
