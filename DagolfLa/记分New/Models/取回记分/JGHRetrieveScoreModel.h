//
//  JGHRetrieveScoreModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHRetrieveScoreModel : BaseModel

// 标题
@property (nonatomic, strong)NSString *title;

// 用户名
@property (nonatomic, strong)NSString *userName;

// 球场名字
@property (nonatomic, strong)NSString *ballName;

// 创建时间
@property (nonatomic, strong)NSString *createtime;

// 来源Key
@property (nonatomic, strong)NSNumber *srcKey;

// 来源Key类型
// 参考 Score.srcType
@property (nonatomic, assign)NSInteger srcType;

// 是否完成记分
// 参考 Score.srcType
@property (nonatomic, assign)NSInteger scoreFinish;

// 总杆数
@property (nonatomic, assign)NSInteger poleNumber;


@end
