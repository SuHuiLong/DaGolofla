//
//  JGHLaunchActivityViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;

@interface JGHLaunchActivityViewController : UIViewController

@property (nonatomic, retain) UIImageView *imgProfile;

@property (nonatomic, assign)NSInteger teamKey;//发布活动teamkey

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@end
