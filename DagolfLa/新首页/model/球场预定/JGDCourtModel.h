//
//  JGDCourtModel.h
//  DagolfLa
//
//  Created by 東 on 16/12/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGDCourtModel : BaseModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *ballName;
@property (nonatomic, copy) NSString *bookName;

@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *type; // 球场类型
@property (nonatomic, assign) NSInteger instapaper; // 2 是 封场

@property (nonatomic, strong) NSNumber *holesSum;
@property (nonatomic, strong) NSNumber *timeKey;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *suggestedPrice; // 建议价

@property (nonatomic, strong) NSNumber *unitPrice; // 单价
@property (nonatomic, strong) NSNumber *deductionMoney; // 减免金额
@property (nonatomic, strong) NSNumber *isLeague; // 1 是联盟球场


@end
