//
//  DisCoveryActivityModel.h
//  DagolfLa
//
//  Created by SHL on 2017/5/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisCoveryActivityModel : NSObject
//球队id
@property (nonatomic,copy) NSString *timeKey;
//已报名人数
@property (nonatomic,assign) long activityCount;
//球场名
@property (nonatomic,copy) NSString *ballName;
//球队名
@property (nonatomic,copy) NSString *ballName1;
//活动名
@property (nonatomic,copy) NSString *name;
//距离
@property (nonatomic,copy) NSString *distance;
//状态
@property (nonatomic,copy) NSString *stateShowString;
//时间
@property (nonatomic,copy) NSString *beginDate;
//费用
@property (nonatomic,copy) NSString *costRange;
@end
