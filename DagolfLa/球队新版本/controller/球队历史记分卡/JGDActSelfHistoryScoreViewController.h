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

@property (nonatomic, copy) NSString *timeKey;
@property (nonatomic, strong) JGLScoreLiveModel *scoreModel;

@end
