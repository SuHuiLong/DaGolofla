//
//  ChartMessage.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
typedef enum {
  
    kMessageFrom=0,
    kMessageTo
 
}ChartMessageType;
#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface ChartMessage :BaseModel
@property (nonatomic,assign) ChartMessageType messageType;
@property (nonatomic, strong) NSString *icon;
//@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDictionary *dict;
@end
