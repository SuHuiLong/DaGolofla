//
//  JGHNewHomePageViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface JGHNewHomePageViewController : ViewController

//定义枚举类型
typedef enum {
    ENUM_ViewController895_ActionTypeStart=0,//开始
    ENUM_ViewController895_ActionTypeStop,//停止
    ENUM_ViewController895_ActionTypePause//暂停
} PushCtrlType;

@property (nonatomic,assign) NSInteger PushType;

@end
