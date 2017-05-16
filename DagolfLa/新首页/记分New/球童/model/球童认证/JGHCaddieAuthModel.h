//
//  JGHCaddieAuthModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHCaddieAuthModel : BaseModel


@property (nonatomic, strong)NSNumber *ballKey;//球场Key
@property (nonatomic, strong)NSString *ballName;//球场名字
@property (nonatomic, strong)NSString *name;//用户名
@property (nonatomic, assign)NSInteger sex;//性别
@property (nonatomic, strong)NSString *number;//编号
@property (nonatomic, strong)NSString *serviceTime;//服务时间
//@property (nonatomic, strong)NSNumber *createTime;//认证时间

@end
