//
//  NoteHandlle.m
//  DagolfLa
//
//  Created by 東 on 16/4/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "NoteHandlle.h"
#import <sqlite3.h>
#import "Helper.h"


@implementation NoteHandlle

static sqlite3 *db = nil;

#pragma mark --打开数据库
+ (sqlite3 *)open{
    
    @synchronized(self){
        
        if (db == nil) {
            
            // 数据库路径
            NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *dbPath = [docPath stringByAppendingPathComponent:@"db.sqlite"];
            
            int result = sqlite3_open(dbPath.UTF8String, &db);
            if (result == SQLITE_OK) {
                
                NSString *sql = @"create table 'newNotes' (otherUserId int primary key not null, userremarks text, userMobile text, userSign text);";
                
                int result2 =  sqlite3_exec(db, sql.UTF8String, nil, nil, nil);
                
                if (result2 == SQLITE_OK) {
                    //                    //NSLog(@"创建数据库表成功");
                }else{
                    //                    //NSLog(@"创建数据库表失败或者已经创建");
                }
            }
        }
    }
    return db;
}



// 关闭数据库
+ (void)close{
    
    sqlite3_close(db);
    
}


+ (void)insertNote:(NoteModel *)note{

    sqlite3 *db = [self open];
    
    NSString *sql = [NSString stringWithFormat:@"insert into  'newNotes' values(%d, '%@', '%@', '%@');",[note.otherUserId intValue], note.userremarks, note.userMobile, note.userSign];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        sqlite3_step(stmt);
    }
    
    sqlite3_finalize(stmt);
    
    
}


// 删除操作
+ (void)deleteMyattenWithUID:(NSNumber *)uid{
    sqlite3 *db = [self open];
    
    NSString *sql = [NSString stringWithFormat:@"delete from 'newNotes' where otherUserId = %d;",[uid intValue]];
    
    int result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil);
    
    if (result == SQLITE_OK) {
        //        //NSLog(@"delete succeed");
    }
}


+ (void)deleteAll{
    sqlite3 *db = [self open];
    NSString *sql = [NSString stringWithFormat:@"delete from 'newNotes'"];
    int result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil);
    if (result) {
        //NSLog(@"delete all");
    }
}



// 查找数据
// 查找某一个备注
+ (NoteModel *)selectNoteWithUID:(NSNumber *)uid{
    
    NoteModel *note = [[NoteModel alloc] init];
    
    sqlite3 *db = [self open];
    
    NSString *sql = [NSString stringWithFormat:@"select * from 'newNotes' where otherUserId = %d;",[uid intValue]];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        
        sqlite3_step(stmt);
        
        int uid = sqlite3_column_int(stmt, 0);
        const unsigned char *userremarks = sqlite3_column_text(stmt, 1);
        const unsigned char *userMobile = sqlite3_column_text(stmt, 2);
        const unsigned char *userSign = sqlite3_column_text(stmt, 3);
        
        
        if (userremarks) {
            NSString *remarks = [NSString stringWithUTF8String:(const char *)userremarks]; // OC
            note.userremarks = remarks;
        }
        if (userMobile) {
            NSString *mobile = [NSString stringWithUTF8String:(const char *)userMobile];
            note.userMobile = mobile;
        }
        if (userSign) {
            NSString *sign = [NSString stringWithUTF8String:(const char *)userSign];
            note.userSign = sign;
        }
        
        note.otherUserId = [NSNumber numberWithInt:uid];
        
    }
    return note;
    
}


// 查找多个球友

+ (NSArray *)selectAllNote{

    NSMutableArray *array  = [NSMutableArray array];
    
    sqlite3 *db = [self open];
    
    NSString *sql = @"select *from 'newNotes';";
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int uid = sqlite3_column_int(stmt, 0);
            
            NSString *userremarks = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *userMobile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            NSString *userSign = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            
            NoteModel *note = [[NoteModel alloc] init];
            note.otherUserId = [NSNumber numberWithInt:uid];
            note.userremarks = userremarks;
            note.userMobile = userMobile;
            note.userSign = userSign;
            [array addObject:note];
            
        }
    }
    return array;
}


// 改
+ (void)updateNoteWithUID:(NSNumber *)uid newInfo:(NoteModel *)note{

    sqlite3 *db = [self open];
    
    NSString *sql = [NSString stringWithFormat:@"update 'newNotes' set userremarks = '%@', userMobile = '%@',userSign = '%@' where otherUserId = %d;", note.userremarks, note.userMobile, note.userSign ,[uid intValue]];
    
    int result = sqlite3_exec(db, sql.UTF8String , nil, nil, nil);
    
    if (result == SQLITE_OK) {
//        //NSLog(@"update succeed");
    }
}



@end
