//
//  CardHIstoryModel.h
//  DagolfLa
//
//  Created by SHL on 2017/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface CardHIstoryModel : BaseModel
//时间
@property(nonatomic,copy)NSString *timeStr;
//卡片类型图片
@property(nonatomic,copy)NSString *picUrl;
//消费地点
@property(nonatomic,copy)NSString *parkStr;
@end
