//
//  JGHScoresViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHBaseScoreViewController.h"

@interface JGHScoresViewController : JGHBaseScoreViewController

@property (nonatomic, strong)NSString *scorekey;

@property (nonatomic, assign)NSInteger backHistory;//1-返回历史积分卡

@property (nonatomic, assign)NSInteger currentPage;

@property (nonatomic, assign)NSInteger isCabbie;//1-球童

//首次进入会有一个提示弹窗
@property (nonatomic,assign) BOOL isAlertView;

@end
