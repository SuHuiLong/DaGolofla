//
//  JGHScoreAF.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHScoreAF.h"
#import "JGHScoreListModel.h"
#import "JGHScoreDatabase.h"

static JGHScoreAF *scoreAF = nil;

@implementation JGHScoreAF

+ (JGHScoreAF *)shareScoreAF{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scoreAF = [[JGHScoreAF alloc]init];
    });
    
    return scoreAF;
}

- (void)submitLocalScoreData{
    if (!DEFAULF_USERID) {
        return;
    }
    
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    NSMutableArray *scoreKeyArray = [NSMutableArray array];
    if ([userdf objectForKey:@"scoreKeyArray"]) {
        //本地存在记分数据 --  请求队列
        scoreKeyArray = [userdf objectForKey:@"scoreKeyArray"];
        NSString *scoreKey;
        for (int i=0; i<scoreKeyArray.count; i++) {
            scoreKey = [NSString stringWithFormat:@"%@", scoreKeyArray[i]];
            
            //获取记分是否提交过 －－ 提交过（退出）
            if (![[JGHScoreDatabase shareScoreDatabase]getScoreSave:scoreKey]) {
                break;
            }
            
            dispatch_queue_t queue = dispatch_queue_create("serialQurur", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                [[JGHScoreAF shareScoreAF]httpScoreKey:scoreKey failedBlock:^(id errType) {
                    
                } completionBlock:^(id data) {
                    if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
                        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                        if (![userdef objectForKey:[NSString stringWithFormat:@"%@list", scoreKey]]) {
                            [userdef setObject:@1 forKey:[NSString stringWithFormat:@"%@list", scoreKey]];
                            [userdef synchronize];
                        }
                        
                        [[JGHScoreDatabase shareScoreDatabase]updateCommitDataScoreKey:scoreKey andCommitData:@"1"];
                    }else{
                        //保存失败
                    }
                }];
            });            
        }
    }
}

- (void)httpScoreKey:(NSString *)scoreKey failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock{
    
    //[[JGHScoreDatabase shareScoreDatabase]initDataBaseTableName:scoreKey];
    
    NSMutableArray *scoreArray = [NSMutableArray array];
    
    scoreArray = [[JGHScoreDatabase shareScoreDatabase]getAllScoreKey:scoreKey];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSMutableArray *listArray = [NSMutableArray array];
    for (JGHScoreListModel *model in scoreArray) {
        NSMutableDictionary *listDict = [NSMutableDictionary dictionary];
        if (model.userKey) {
            [listDict setObject:model.userKey forKey:@"userKey"];// 用户Key
        }else{
            [listDict setObject:@(0) forKey:@"userKey"];// 用户Key
        }
        
        [listDict setObject:model.userName forKey:@"userName"];// 用户名称
        if (model.userMobile) {
            [listDict setObject:model.userMobile forKey:@"userMobile"];// 手机号
        }else{
            [listDict setObject:@"" forKey:@"userMobile"];// 手机号
        }
        if (model.tTaiwan) {
            [listDict setObject:model.tTaiwan forKey:@"tTaiwan"];// T台
        }else{
            [listDict setObject:@"" forKey:@"tTaiwan"];// T台
        }
        
        [listDict setObject:model.region1 forKey:@"region1"];//region1
        [listDict setObject:model.region2 forKey:@"region2"];//region2
        [listDict setObject:model.poleNameList forKey:@"poleNameList"];// 球洞名称
        [listDict setObject:model.poleNumber forKey:@"poleNumber"];// 球队杆数
        [listDict setObject:model.pushrod forKey:@"pushrod"];// 推杆
        [listDict setObject:model.onthefairway forKey:@"onthefairway"];// 是否上球道
        [listDict setObject:model.timeKey forKey:@"timeKey"];// 是否上球道
        [listDict setObject:@(model.switchMode) forKey:@"scoreModel"];//记分模式
        
        [listArray addObject:listDict];
    }
    
    [dict setObject:listArray forKey:@"list"];
    
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"score/saveScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        failedBlock(errType);
    } completionBlock:^(id data) {
        //_item.enabled = YES;
        NSLog(@"%@", data);
        completionBlock(data);
    }];
}

- (void)httpFinishScoreKey:(NSString *)scoreKey failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock{
    NSMutableDictionary *finishDict = [NSMutableDictionary dictionary];
    [finishDict setObject:DEFAULF_USERID forKey:@"userKey"];
    [finishDict setObject:scoreKey forKey:@"scoreKey"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/finishScore" JsonKey:nil withData:finishDict failedBlock:^(id errType) {
        failedBlock(errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        completionBlock(data);
    }];
}


@end
