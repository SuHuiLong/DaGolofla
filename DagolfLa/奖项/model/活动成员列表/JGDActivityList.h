//
//  JGDActivityList.h
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGDActivityList : BaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *signUpInfoKey;
@property (nonatomic, strong) NSNumber *mobile;
@property (nonatomic, strong) NSNumber *userKey;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSNumber *timeKey;

@end
