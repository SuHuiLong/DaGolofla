//
//  NoteHandlle.h
//  DagolfLa
//
//  Created by 東 on 16/4/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NoteModel.h"

@interface NoteHandlle : NSObject



+ (sqlite3 *)open;


// 关闭数据库
+ (void)close;

// 数据库表的相关操作 增删改查
// 增加备注
+ (void)insertNote:(NoteModel *)note;

// 更改备注 根据uid更改
+ (void)updateNoteWithUID:(NSNumber *)uid newInfo:(NoteModel *)note;


// 查询
// 查询某一个备注 根据 uid 返回
+ (NoteModel *)selectNoteWithUID:(NSNumber *)uid;

// 查询所有备注 返回值为 NSArray
+ (NSArray *)selectAllNote;

+ (void)deleteAll;

@end
