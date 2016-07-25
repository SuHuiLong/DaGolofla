//
//  JGHEndScoresViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import <ALBBQuPaiPlugin/ALBBQuPaiPluginPluginServiceProtocol.h>
#import <ALBBQuPaiPlugin/QPEffectMusic.h>

@interface JGHEndScoresViewController : ViewController

//1. 从“活动历史积分卡“页面进入
//2. 从“活动历史积分卡个人详情页面进入“
//3. 从“非活动历史积分卡“页面进入
//4. 从“非活动历史积分卡个人详情"页面进入

//@property (nonatomic, assign)NSInteger *souressCtrl;

typedef void(^BlockRereshingk)();
@property(nonatomic,copy)BlockRereshingk blockRereshing;

@property (nonatomic, strong)NSMutableDictionary *dict;


@end
