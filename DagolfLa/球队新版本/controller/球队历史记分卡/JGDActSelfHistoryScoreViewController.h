//
//  JGDActSelfHistoryScoreViewController.h
//  DagolfLa
//
//  Created by 東 on 16/7/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLScoreLiveModel.h"

@interface JGDActSelfHistoryScoreViewController : ViewController

@property (nonatomic, strong) NSNumber *teamKey;
@property (nonatomic, copy) NSString *timeKey;  // srcKey
@property (nonatomic, strong) JGLScoreLiveModel *scoreModel;

@property (nonatomic, assign) NSInteger fromManeger;  // 从非管理页面进入传 6
@property (nonatomic, strong) NSNumber *srcKey;
@property (nonatomic, strong) NSNumber *userKey;
@property (nonatomic, strong) NSNumber *scoreKey;

@end
