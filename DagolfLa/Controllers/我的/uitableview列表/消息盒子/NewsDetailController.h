//
//  NewsDetailController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/30.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "NewsModel.h"
@interface NewsDetailController : ViewController
//判断是否是系统消息
//0是系统消息，否则为聊天消息
@property (assign, nonatomic) NSInteger indexType;


@property (strong, nonatomic) NSNumber* messType;


//@property (assign, nonatomic) NSInteger chooseNum;

//@property (strong, nonatomic) NewsModel* model;
@end
