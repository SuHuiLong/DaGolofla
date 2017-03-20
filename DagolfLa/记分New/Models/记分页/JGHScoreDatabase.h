//
//  JGHScoreDatabase.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGHScoreListModel;

@interface JGHScoreDatabase : NSObject

+ (JGHScoreDatabase *)shareScoreDatabase;

//添加
- (void)addJGHScoreListModel:(JGHScoreListModel *)scoreModel;

//查询本地是否存在记录
- (BOOL)selectScoreModel:(NSString *)scorekey;

//更新 -- PoleNumber
- (void)updatePoleNumber:(JGHScoreListModel *)scoreModel;

//更新 -- standardlever
- (void)updateStandardlever:(JGHScoreListModel *)scoreModel;

//更新 -- pushrod
- (void)updatePushrod:(JGHScoreListModel *)scoreModel;

//更新 -- onthefairway
- (void)updateOnthefairway:(JGHScoreListModel *)scoreModel;

//更新 -- poleNameList
- (void)updatePoleNameList:(JGHScoreListModel *)scoreModel;

//获取所有数据
- (NSMutableArray *)getAllScore;

@end
