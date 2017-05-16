//
//  ActivityMyApplyViewModel.h
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityMyApplyViewModel : NSObject

//球队id
@property (nonatomic,copy) NSString *teamKey;
//
@property (nonatomic,copy) NSString *timeKey;
//活动key
@property (assign, nonatomic) NSInteger teamActivityKey;
//已报名人数
@property (nonatomic,assign) long sumCount;
//总人数 0：不限制人身
@property (nonatomic,assign) long maxCount;
//球场名
@property (nonatomic,copy) NSString *ballName;
//活动名
@property (nonatomic,copy) NSString *name;
//状态
@property (nonatomic,copy) NSString *stateShowString;
//后台保存的转态
@property (nonatomic,copy) NSString *stateButtonString;
//时间
@property (nonatomic,copy) NSString *beginDate;
//费用
@property (nonatomic,copy) NSString *costRange;

@end
