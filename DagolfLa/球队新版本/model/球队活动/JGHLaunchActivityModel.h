//
//  JGHLaunchActivityModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGHLaunchActivityModel : NSObject
//活动图片
@property (nonatomic, strong)UIImageView *teamPhotoImage;
//活动名称
@property (nonatomic, copy)NSString *teamName;
//开始时间
@property (nonatomic, copy)NSString *startDate;
//结束时间
@property (nonatomic, copy)NSString *endDate;
//活动地点
@property (nonatomic, copy)NSString *activityAddress;
//活动简介
@property (nonatomic, copy)NSString *activityInfo;
//费用说明
@property (nonatomic, copy)NSString *payInfo;
//奖项设置
@property (nonatomic, copy)NSString *setAward;
//费用设置－－球队会员费
@property (nonatomic, copy)NSString *membersCost;
//嘉宾费用
@property (nonatomic, copy)NSString *guestCost;
//人员限制
@property (nonatomic, copy)NSString *limits;

@end
