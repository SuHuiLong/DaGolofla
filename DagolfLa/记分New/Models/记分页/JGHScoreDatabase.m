//
//  JGHScoreDatabase.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHScoreDatabase.h"
#import "FMDB.h"
#import "JGHScoreListModel.h"

static JGHScoreDatabase *scoreDatabase = nil;

@interface JGHScoreDatabase ()
{
    FMDatabase *_db;
}

@end

@implementation JGHScoreDatabase

+ (JGHScoreDatabase *)shareScoreDatabase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scoreDatabase = [[JGHScoreDatabase alloc]init];
        [scoreDatabase initDataBase];
    });
    
    return scoreDatabase;
}
#pragma mark -- 创建表
- (void)initDataBase{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"scoreModel.sqlite"];
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
    NSString *scoreSql = @"CREATE TABLE 'score' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'timeKey' VARCHAR(255),'userKey' VARCHAR(255),'userName' VARCHAR(255),'userMobile'VARCHAR(255),'almost'VARCHAR(255),'tTaiwan'VARCHAR(255),'poleNumber'VARCHAR(255),'standardlever'VARCHAR(255),'pushrod'VARCHAR(255),'onthefairway'VARCHAR(255),'poleNameList'VARCHAR(255),'region1'VARCHAR(255),'region2'VARCHAR(255),'score'VARCHAR(255),'ballAreas'VARCHAR(255))";
    
    [_db executeUpdate:scoreSql];
    
    [_db close];
}

- (BOOL)selectScoreModel:(NSString *)scorekey{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM score WHERE timeKey = %@", scorekey]];
    
    BOOL result;
    
    if ([res next]) {
        result = YES;
    }else{
        result = NO;
    }
    
    [_db close];
    
    return result;
}

- (void)addJGHScoreListModel:(JGHScoreListModel *)scoreModel{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM score WHERE timeKey = %@", scoreModel.timeKey]];
    
    //如果在数据库中找到记录, update;否则插入新纪录
    if ([res next]) {
        //本地存在数据  不处理, 取本地的
        //更新
        //[self updateJGHScoreListModel:scoreModel];
    }else{
        //插入
        BOOL result = [_db executeUpdate:@"INSERT INTO score(timeKey, userKey, userName, userMobile, almost, tTaiwan, poleNumber, standardlever, pushrod, onthefairway, poleNameList, region1, region2, score, ballAreas)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", scoreModel.timeKey, scoreModel.userKey, scoreModel.userName, scoreModel.userMobile, scoreModel.almost, scoreModel.tTaiwan, [scoreModel.poleNumber componentsJoinedByString:@","], [scoreModel.standardlever componentsJoinedByString:@","], [scoreModel.pushrod componentsJoinedByString:@","], [scoreModel.onthefairway componentsJoinedByString:@","], [scoreModel.poleNameList componentsJoinedByString:@","], scoreModel.region1, scoreModel.region2, [Helper dictionaryToJson:scoreModel.score], [scoreModel.ballAreas componentsJoinedByString:@","]];
        if (result) {
            
        }
    }
    
    [_db close];
}

- (void)updatePoleNumber:(JGHScoreListModel *)scoreModel{
    [_db open];
    [_db executeUpdate:@"UPDATE 'score' SET poleNumber = ?  WHERE timeKey = ? and userKey = ?", [scoreModel.poleNumber componentsJoinedByString:@","], scoreModel.timeKey, scoreModel.userKey];
    
    [_db close];
}
//更新 -- standardlever
- (void)updateStandardlever:(JGHScoreListModel *)scoreModel{
    [_db open];
    [_db executeUpdate:@"UPDATE 'score' SET standardlever = ?  WHERE timeKey = ? and userKey = ?", [scoreModel.standardlever componentsJoinedByString:@","], scoreModel.timeKey, scoreModel.userKey];
    
    [_db close];
}

//更新 -- pushrod
- (void)updatePushrod:(JGHScoreListModel *)scoreModel{
    [_db open];
    [_db executeUpdate:@"UPDATE 'score' SET pushrod = ?  WHERE timeKey = ? and userKey = ?", [scoreModel.pushrod componentsJoinedByString:@","], scoreModel.timeKey, scoreModel.userKey];
    
    [_db close];
}

//更新 -- onthefairway
- (void)updateOnthefairway:(JGHScoreListModel *)scoreModel{
    [_db open];
    [_db executeUpdate:@"UPDATE 'score' SET onthefairway = ?  WHERE timeKey = ? and userKey = ?", [scoreModel.onthefairway componentsJoinedByString:@","], scoreModel.timeKey, scoreModel.userKey];
    
    [_db close];
}

//更新 -- poleNameList
- (void)updatePoleNameList:(JGHScoreListModel *)scoreModel{
    [_db open];
    [_db executeUpdate:@"UPDATE 'score' SET poleNameList = ?  WHERE timeKey = ? and userKey = ?", [scoreModel.poleNameList componentsJoinedByString:@","], scoreModel.timeKey, scoreModel.userKey];
    
    [_db close];
}

- (NSMutableArray *)getAllScore{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM person"];
    
    while ([res next]) {
        JGHScoreListModel *scoreModel = [[JGHScoreListModel alloc] init];
        scoreModel.timeKey = [NSNumber numberWithInteger:[[res stringForColumn:@"timeKey"] integerValue]];
        scoreModel.userKey = [NSNumber numberWithInteger:[[res stringForColumn:@"userKey"] integerValue]];
        scoreModel.userName = [res stringForColumn:@"userName"];
        scoreModel.userMobile = [res stringForColumn:@"userMobile"];
        scoreModel.almost = [NSNumber numberWithInteger:[[res stringForColumn:@"almost"] integerValue]];
        scoreModel.tTaiwan = [res stringForColumn:@"tTaiwan"];
        scoreModel.poleNumber = [NSArray arrayWithArray:[[res stringForColumn:@"poleNumber"] componentsSeparatedByString:@","]];
        
        scoreModel.standardlever = [NSArray arrayWithArray:[[res stringForColumn:@"standardlever"] componentsSeparatedByString:@","]];
        
        scoreModel.pushrod = [NSArray arrayWithArray:[[res stringForColumn:@"pushrod"] componentsSeparatedByString:@","]];
        
        scoreModel.onthefairway = [NSArray arrayWithArray:[[res stringForColumn:@"onthefairway"] componentsSeparatedByString:@","]];
        
        scoreModel.poleNameList = [NSArray arrayWithArray:[[res stringForColumn:@"poleNameList"] componentsSeparatedByString:@","]];
        
        scoreModel.region1 = [res stringForColumn:@"region1"];
        scoreModel.region2 = [res stringForColumn:@"region2"];
        
        scoreModel.score = [Helper dictionaryWithJsonString:[res stringForColumn:@"score"]];
        
        scoreModel.ballAreas = [NSArray arrayWithArray:[[res stringForColumn:@"ballAreas"] componentsSeparatedByString:@","]];
        
        //[NSArray arrayWithArray:[person.carString componentsSeparatedByString:@","]];
        
        [dataArray addObject:scoreModel];
        
    }
    
    [_db close];
    
    return dataArray;
}

@end
