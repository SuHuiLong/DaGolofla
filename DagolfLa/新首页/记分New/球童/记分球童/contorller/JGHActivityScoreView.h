//
//  JGHActivityScoreView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLChooseScoreModel;

@interface JGHActivityScoreView : UIView

//活动积分，类似于球童活动积分内容
@property (strong, nonatomic) JGLChooseScoreModel* model;


@property (copy, nonatomic) void (^blockSelectActivityScore)(NSString *);

@property (copy, nonatomic) void (^blockSelectActivityScoreDate)();//时间

@property (copy, nonatomic) void (^blockSelectActivityScorePalyer)(NSMutableArray *, JGLChooseScoreModel *);

- (void)reloadTime:(NSString *)time;

- (void)reloadPalyerArray:(NSMutableArray *)palerArray;

- (void)reloadData:(JGLChooseScoreModel *)model;

@end
