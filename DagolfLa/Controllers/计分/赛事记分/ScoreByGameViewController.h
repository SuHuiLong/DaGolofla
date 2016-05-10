//
//  ScoreByGameViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface ScoreByGameViewController : ViewController
{
    //声明一个BOOL类型的数组 里面存放BOOL数据类型 里面有3个空间 声明方式 数组类型 数组名【元素个数】
    BOOL _isOpen[3];
}
//数据源 全局字典
@property (retain, nonatomic) NSDictionary *globalDictionary;

//
//@property (strong, nonatomic) NSString* strSelfTitle;

//标题
@property (strong, nonatomic) NSString* strTitle;
//图片
@property (strong, nonatomic) NSString* pic;
//球场名称
@property (strong, nonatomic) NSString* ballName;
//创建时间
@property (strong, nonatomic) NSString* createTime;
//球场id
@property (assign, nonatomic) NSInteger ballId;
//记分类型
@property (strong, nonatomic) NSNumber* scoreType;

@property (strong, nonatomic) NSNumber* eventObjId;

@property (strong, nonatomic) NSNumber* isSave;

@end
