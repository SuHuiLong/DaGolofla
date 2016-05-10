//
//  CaptchaModel.h
//  DaGolfla
//
//  Created by bhxx on 15/9/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface CaptchaModel : BaseModel

@property (copy, nonatomic) NSString* rows, * message;

@property (assign, nonatomic) BOOL success;


+(NSMutableArray *)parsingWithJSONData:(NSData *)data;

@end

/*
 {
 "rows": 123456,
 "message": "验证码已发送",
 "success": true,
 "total": 0,
 "flg": 0
 }
 
 */