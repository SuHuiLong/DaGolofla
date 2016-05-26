//
//  InvoiceModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface InvoiceModel : BaseModel

@property (assign, nonatomic)NSInteger delFlag;

@property (assign, nonatomic)NSInteger syncFlag;

@property (assign, nonatomic)NSInteger douDef2;

@property (assign, nonatomic)NSInteger type;//发票类型

@property (copy, nonatomic)NSString *title;//发票抬头

@property (copy, nonatomic)NSString *timeKey;

@property (copy, nonatomic)NSString *userKey;//用户Key

@property (copy, nonatomic)NSString *info;//发票内容

@property (copy, nonatomic)NSString *name;//发票名称

@property (copy, nonatomic)NSString *ts;

@property (assign, nonatomic)NSInteger douDef1;

@property (assign, nonatomic)NSInteger rsyncFlag;



@end
