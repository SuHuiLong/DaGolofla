//
//  JGLAddPlayerViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

//添加打球人界面，


@interface JGLCaddieSelfAddPlayerViewController : ViewController


@property (copy, nonatomic) void (^blockSurePlayer)(NSMutableDictionary *);//之前还有个功能暂未实现：添加打球人将数据返回到上一层页面，再回当前页面没有带值过来。
//一直没有解决


@property (strong, nonatomic) NSString* strPlayerName;

@property (copy, nonatomic) NSMutableDictionary* dictPeople, *peoAddress,* peoFriend;
//通讯录返回数据    peoAddress
//球友列表返回数据;   _peoFriend
@end
