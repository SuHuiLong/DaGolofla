//
//  JGHAwardModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHAwardModel : BaseModel

@property (nonatomic, strong)NSNumber *prizeSize;

@property (nonatomic, strong)NSString *teamKey;

@property (nonatomic, strong)NSString *prizeName;

@property (nonatomic, strong)NSString *teamActivityKey;

@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSString *timeKey;

@property (nonatomic, assign)NSInteger select;

@property (nonatomic, strong)NSString *signupKeyInfo;

@property (nonatomic, strong)NSString *userInfo;

@property (nonatomic, strong) NSNumber *isDefault;

@end
