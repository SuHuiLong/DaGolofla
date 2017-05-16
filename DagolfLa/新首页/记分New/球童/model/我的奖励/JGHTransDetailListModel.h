//
//  JGHTransDetailListModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHTransDetailListModel : BaseModel

/**
 amount = 18;
 balance = 300;
 delFlag = 0;
 douDef1 = 0;
 douDef2 = 0;
 exchangeTime = "2016-07-02 13:07:26";
 name = "\U5174\U4e1a\U94f6\U884c(4949)";
 orderKey = 5609;
 orderType = 7;
 rsyncFlag = 0;
 serialNumber = 201607021307264485610;
 srcKey = 5471;
 state = 1;
 syncFlag = 0;
 timeKey = 5610;
 transMRethod = 3;
 transSrc = 0;
 transType = 1;
 ts = "2016-07-02 13:07:26";
 userKey = 244;
 */

@property (nonatomic, strong)NSNumber *amount;
@property (nonatomic, strong)NSNumber *balance;
@property (nonatomic, strong)NSString *exchangeTime;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, assign)NSInteger orderKey;
@property (nonatomic, assign)NSInteger orderType;
@property (nonatomic, strong)NSString *serialNumber;



@end
