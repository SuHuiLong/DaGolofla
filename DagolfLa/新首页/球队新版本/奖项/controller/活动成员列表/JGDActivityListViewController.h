//
//  JGDActivityListViewController.h
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGHAwardModel;

@protocol JGDActivityListViewControllerDelegate <NSObject>

- (void)saveBtnDict:(NSMutableDictionary *)dict andAwardId:(NSInteger)awardId;

@end

@interface JGDActivityListViewController : ViewController

@property (nonatomic, weak)id <JGDActivityListViewControllerDelegate> delegate;

@property(nonatomic,copy)void(^block)(NSInteger str,NSString *str1,NSString *str2);

@property (nonatomic, assign) NSInteger activityKey;

@property (nonatomic, strong) NSMutableDictionary *checkdict;

@property (nonatomic, assign)NSInteger awardId;

@property (nonatomic, strong)JGHAwardModel *awardModel;


@end
