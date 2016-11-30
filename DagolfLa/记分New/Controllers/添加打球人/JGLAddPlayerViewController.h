//
//  JGLAddPlayerViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLAddPlayerViewController : ViewController


@property (copy, nonatomic) void (^blockSurePlayer)(NSMutableDictionary *,NSMutableDictionary*,NSMutableDictionary*);

@property (copy, nonatomic) NSMutableDictionary* dictPeople, *peoAddress,* peoFriend;
//通讯录返回数据    peoAddress
//球友列表返回数据;   _peoFriend

@property (nonatomic, retain)NSMutableArray *preListArray;

@end
