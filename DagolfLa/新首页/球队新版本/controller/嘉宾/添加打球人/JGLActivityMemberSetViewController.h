//
//  JGLActivityMemberSetViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLChooseScoreModel.h"
@protocol JGLActivityMemberSetViewControllerDelegate <NSObject>

- (void)reloadActivityMemberData;

@end

@interface JGLActivityMemberSetViewController : ViewController
@property (strong, nonatomic) JGLChooseScoreModel* model;//
//分组id
@property (strong, nonatomic) NSNumber* teamKey;
//活动id
@property (strong, nonatomic) NSNumber* activityKey;
@property (weak, nonatomic)id <JGLActivityMemberSetViewControllerDelegate> delegate;

@end
