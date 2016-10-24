//
//  JGHMatchRoundModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHMatchRoundModel : BaseModel

@property (nonatomic, strong)NSNumber *matchKey;//赛事id

@property (nonatomic, strong)NSString *kickOffTime;//开球时间

@property (nonatomic, strong)NSNumber *ballKey;//球场id

@property (nonatomic, strong)NSString *ballName;//球场名字

@property (nonatomic, strong)NSString *ruleType;//比赛类型

@property (nonatomic, strong)NSNumber *matchTypeKey;//赛事类型key

@property (nonatomic, strong)NSNumber *matchformatKey;//赛制key

@property (nonatomic, assign)NSInteger matchformatPeopleConut;//赛制人数

@property (nonatomic, strong)NSString *ruleJson;//规则json

@property (nonatomic, assign)NSInteger round;//轮次


@end
