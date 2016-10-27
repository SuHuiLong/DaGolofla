//
//  JGHIndexModel.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHIndexModel.h"

@implementation JGHIndexModel

/*
 @property (nonatomic, strong)NSArray *activityList;
 
 @property (nonatomic, strong)NSArray *albumList;
 
 @property (nonatomic, strong)NSArray *plateList;
 
 @property (nonatomic, strong)NSArray *scoreList;
 */

#pragma mark 将对象归档的时候会调用（将对象写入文件前会调用）
//在这个方法说清楚
//哪些属性需要存储
//怎样存储这些属性
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //将_name属性进行编码
    [encoder encodeObject:_activityList forKey:@"activityList"];
    
    [encoder encodeObject:_albumList forKey:@"albumList"];
    
    [encoder encodeObject:_plateList forKey:@"plateList"];
    
    [encoder encodeObject:_scoreList forKey:@"scoreList"];
}

#pragma mark 当从对象中解析时 调用。
//这个方法说清楚
//1.哪些属性需要解析
//2，怎样解析这些属性
-(id)initWithCoder:(NSCoder *)decode
{
    if (self = [super init]) {
        _activityList = [decode decodeObjectForKey:@"activityList"];
        _albumList = [decode decodeObjectForKey:@"albumList"];
        _plateList = [decode decodeObjectForKey:@"plateList"];
        _scoreList = [decode decodeObjectForKey:@"scoreList"];
    }
    return self;
}

@end
