//
//  ScoreByActiveViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface ScoreByActiveViewController : ViewController
{
    //声明一个BOOL类型的数组 里面存放BOOL数据类型 里面有3个空间 声明方式 数组类型 数组名【元素个数】
    BOOL _isOpen[3];
}
//数据源 全局字典
@property (retain, nonatomic) NSDictionary *globalDictionary;

//@property (strong, nonatomic) NSString* strSelfTitle;

@property (strong, nonatomic) NSString* strTitle;

@property (strong, nonatomic) NSString* pic;

@property (strong, nonatomic) NSString* ballName;

@property (strong, nonatomic) NSString* createTime;

@property (assign, nonatomic) NSInteger ballId;

@property (strong, nonatomic) NSNumber* scoreType;


@property (strong, nonatomic) NSNumber* activeObjId;
@property (strong, nonatomic) NSNumber* isSave;

@end
