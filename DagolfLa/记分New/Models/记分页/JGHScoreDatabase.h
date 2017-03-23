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

//创建表
- (void)initDataBaseTableName:(NSString *)tableName;

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

//更新 -- onthefairway －－ 是否上球道
- (void)updateOnthefairway:(JGHScoreListModel *)scoreModel;

//更新 -- poleNameList
- (void)updatePoleNameList:(JGHScoreListModel *)scoreModel;

//更新记分模式
- (void)updateSwithModel:(NSInteger)scoreModel andScoreKey:(NSString *)scoreKey;

//更新---commitData ＝＝0 表示新的操作，未提交服务器，1表示已提交
- (void)updateCommitDataScoreKey:(NSString *)scoreKey andCommitData:(NSString *)commitData;

//查询 －－记分数据是否已经提交成功
- (BOOL)getScoreSave:(NSString *)scoreKey;

//获取所有数据
- (NSMutableArray *)getAllScore;

//删除表
- (BOOL)deleteTable:(NSString *)tableName;

@end
