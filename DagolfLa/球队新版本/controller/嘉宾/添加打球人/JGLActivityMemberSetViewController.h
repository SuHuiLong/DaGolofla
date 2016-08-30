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
@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSNumber* activityKey;

@property (weak, nonatomic)id <JGLActivityMemberSetViewControllerDelegate> delegate;

@end
