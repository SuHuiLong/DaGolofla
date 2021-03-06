//
//  JGHIndexModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"
#import <Foundation/Foundation.h>

@interface JGHIndexModel : BaseModel <NSCoding>

@property (nonatomic, strong)NSArray *activityList;

@property (nonatomic, strong)NSArray *albumList;

@property (nonatomic, strong)NSArray *plateList;

@property (nonatomic, strong)NSArray *scoreList;

@property (nonatomic, assign)NSInteger isHaveTeam;

@property (nonatomic, strong)NSArray *videoNewList;

@property (nonatomic, strong)NSArray *ballSkillNewList;

@property (nonatomic, strong)NSArray *activityNewList;

@property (nonatomic, strong)NSArray *matchNewList;

@property (nonatomic, strong)NSDictionary *Msg;

@end


/*
 
 #import <Foundation/Foundation.h>
 @interface JPerson : NSObject <NSCoding>
 @property(nonatomic,copy)NSString *name;
 @property(nonatomic,assign)int age;
 @property(nonatomic,assign)double height;
 @end
 
 */
