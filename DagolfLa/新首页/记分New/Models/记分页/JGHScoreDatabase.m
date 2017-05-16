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
    
    //NSString *_tableName;
}

@end

@implementation JGHScoreDatabase

+ (JGHScoreDatabase *)shareScoreDatabase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scoreDatabase = [[JGHScoreDatabase alloc]init];
    });
    
    return scoreDatabase;
}
#pragma mark -- 创建表
- (void)initDataBaseTableName:(NSString *)tableName{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"DATA_%@.sqlite", tableName]];
    
    //_tableName = tableName;
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表 -- commitData 保存服务器是否成功
    NSString *scoreSql = [NSString stringWithFormat:@"CREATE TABLE Table_%@ ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'timeKey' VARCHAR(255),'userKey' VARCHAR(255),'userName' VARCHAR(255),'userMobile'VARCHAR(255),'almost'VARCHAR(255),'tTaiwan'VARCHAR(255),'poleNumber'VARCHAR(255),'standardlever'VARCHAR(255),'pushrod'VARCHAR(255),'onthefairway'VARCHAR(255),'poleNameList'VARCHAR(255),'region1'VARCHAR(255),'region2'VARCHAR(255),'areaArray'VARCHAR(255),'score'VARCHAR(255),'ballAreas'VARCHAR(255),'finish'VARCHAR(255),'switchMode'VARCHAR(255), 'commitData'VARCHAR(255))", tableName];
    
    [_db executeUpdate:scoreSql];
    
    [_db close];
}

- (BOOL)selectScoreModel:(NSString *)scorekey{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM Table_%@ WHERE timeKey = %@", scorekey, scorekey]];
    
    BOOL result;
    
    if ([res next]) {
        result = YES;
    }else{
        result = NO;
    }
    
    [_db close];
    
    return result;
}

- (void)addJGHScoreListModel:(JGHScoreListModel *)scoreModel andScoreKey:(NSString *)scoreKey{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM Table_%@ WHERE timeKey = %@", scoreKey, scoreModel.timeKey]];
    
    //如果在数据库中找到记录, update;否则插入新纪录
    if ([res next]) {
        //本地存在数据  不处理, 取本地的
        //更新
        //[self updateJGHScoreListModel:scoreModel];
    }else{
        //插入
        NSString *tableName = [NSString stringWithFormat:@"Table_%@", scoreKey];
        NSString *sqlColumnMStr = @"timeKey, userKey, userName, userMobile, almost, tTaiwan, poleNumber, standardlever, pushrod, onthefairway, poleNameList, region1, region2, areaArray, score, ballAreas, finish, switchMode, commitData";
        NSString *valueString = @"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?";
        NSArray *sqlValues = [NSArray arrayWithObjects:scoreModel.timeKey, scoreModel.userKey, scoreModel.userName, (scoreModel.userMobile)?scoreModel.userMobile:@"", (scoreModel.almost)?scoreModel.almost:@"", scoreModel.tTaiwan, [scoreModel.poleNumber componentsJoinedByString:@","], [scoreModel.standardlever componentsJoinedByString:@","], [scoreModel.pushrod componentsJoinedByString:@","], [scoreModel.onthefairway componentsJoinedByString:@","], [scoreModel.poleNameList componentsJoinedByString:@","], scoreModel.region1, scoreModel.region2, [scoreModel.areaArray componentsJoinedByString:@","], [Helper dictionaryToJson:scoreModel.score], [scoreModel.ballAreas componentsJoinedByString:@","], scoreModel.finish, [NSString stringWithFormat:@"%td", scoreModel.switchMode], @"1", nil];
        NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)", tableName, sqlColumnMStr, valueString];
        
        BOOL result = [_db executeUpdate:insertSql withArgumentsInArray:sqlValues];
        if (result) {
            
        }
    }
    
    [_db close];
}

- (void)updatePoleNumber:(JGHScoreListModel *)scoreModel andScoreKey:(NSString *)scoreKey{
    [_db open];
    NSString *poleStr = [NSString stringWithFormat:@"%@", [scoreModel.poleNumber componentsJoinedByString:@","]];
    poleStr = [NSString stringWithFormat:@"\"%@\"", poleStr];
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE Table_%@ SET poleNumber = %@ WHERE timeKey = %@ and userKey = %@", scoreKey, poleStr, scoreModel.timeKey, scoreModel.userKey]];
    [self updateCommitDataScoreKey:scoreKey andCommitData:@"0"];
    [_db close];
}
//更新 -- standardlever
- (void)updateStandardlever:(JGHScoreListModel *)scoreModel andScoreKey:(NSString *)scoreKey{
    [_db open];
    NSString *standardlever = [NSString stringWithFormat:@"%@", [scoreModel.standardlever componentsJoinedByString:@","]];
    standardlever = [NSString stringWithFormat:@"\"%@\"", standardlever];
    
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE Table_%@ SET standardlever = %@  WHERE timeKey = %@ and userKey = %@", scoreKey, standardlever, scoreModel.timeKey, scoreModel.userKey]];
    [self updateCommitDataScoreKey:scoreKey andCommitData:@"0"];
    
    [_db close];
}

//更新 -- pushrod
- (void)updatePushrod:(JGHScoreListModel *)scoreModel andScoreKey:(NSString *)scoreKey{
    [_db open];
    
    NSString *pushrod = [NSString stringWithFormat:@"%@", [scoreModel.pushrod componentsJoinedByString:@","]];
    pushrod = [NSString stringWithFormat:@"\"%@\"", pushrod];
    
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE Table_%@ SET pushrod = %@ WHERE timeKey = %@ and userKey = %@", scoreKey, pushrod, scoreModel.timeKey, scoreModel.userKey]];
    [self updateCommitDataScoreKey:scoreKey andCommitData:@"0"];
    
    [_db close];
}

//更新 -- onthefairway －－ 是否上球道
- (void)updateOnthefairway:(JGHScoreListModel *)scoreModel andScoreKey:(NSString *)scoreKey{
    [_db open];
    
    NSString *onthefairway = [NSString stringWithFormat:@"%@", [scoreModel.onthefairway componentsJoinedByString:@","]];
    onthefairway = [NSString stringWithFormat:@"\"%@\"", onthefairway];
    
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE Table_%@ SET onthefairway = %@  WHERE timeKey = %@ and userKey = %@", scoreKey, onthefairway, scoreModel.timeKey, scoreModel.userKey]];
    [self updateCommitDataScoreKey:scoreKey andCommitData:@"0"];
    
    [_db close];
}

//更新 -- poleNameList
- (void)updatePoleNameList:(JGHScoreListModel *)scoreModel andScoreKey:(NSString *)scoreKey{
    [_db open];
    
    NSString *poleNameList = [NSString stringWithFormat:@"%@", [scoreModel.poleNameList componentsJoinedByString:@","]];
    poleNameList = [NSString stringWithFormat:@"\"%@\"", poleNameList];
    
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE Table_%@ SET poleNameList = %@  WHERE timeKey = %@ and userKey = %@", scoreKey, poleNameList, scoreModel.timeKey, scoreModel.userKey]];
    [self updateCommitDataScoreKey:scoreKey andCommitData:@"0"];
    
    [_db close];
}

- (void)updateSwithModel:(NSInteger)scoreModel andScoreKey:(NSString *)scoreKey{
    [_db open];
    
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE Table_%@ SET switchMode = %@", scoreKey, [NSString stringWithFormat:@"%td", scoreModel]]];
    [self updateCommitDataScoreKey:scoreKey andCommitData:@"0"];
    
    [_db close];
}

//更新---commitData ＝＝0 表示新的操作，未提交服务器，1表示已提交
- (void)updateCommitDataScoreKey:(NSString *)scoreKey andCommitData:(NSString *)commitData{
    [_db open];
    
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE Table_%@ SET commitData =%@", scoreKey, commitData]];
    
    [_db close];
}

//查询 －－记分数据是否已经提交成功
- (BOOL)getScoreSave:(NSString *)scoreKey{
    [_db open];
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM Table_%@ WHERE commitData = 0", scoreKey]];
    
    BOOL isHave = [res next];
    
    [_db close];
    
    return isHave;
}

- (NSMutableArray *)getAllScoreKey:(NSString *)scoreKey{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM Table_%@", scoreKey]];
    
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
        
        scoreModel.areaArray = [NSArray arrayWithArray:[[res stringForColumn:@"areaArray"] componentsSeparatedByString:@","]];
        
        scoreModel.score = [Helper dictionaryWithJsonString:[res stringForColumn:@"score"]];
        
        scoreModel.ballAreas = [NSArray arrayWithArray:[[res stringForColumn:@"ballAreas"] componentsSeparatedByString:@","]];
        
        //[NSArray arrayWithArray:[person.carString componentsSeparatedByString:@","]];
        
        [dataArray addObject:scoreModel];
        
    }
    
    [_db close];
    
    return dataArray;
}

- (BOOL)deleteTableScoreKey:(NSString *)scoreKey{
    [_db open];
    
    BOOL res = [_db executeUpdate:[NSString stringWithFormat:@"DROP TABLE Table_%@", scoreKey]];
    
    [_db close];
    
    return res;
}

@end
