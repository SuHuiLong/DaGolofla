//
//  JGLBarCodeViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLBarCodeViewController : ViewController
//二维码添加好友
@property (copy, nonatomic) void (^blockDict)(NSMutableDictionary* );

@property (nonatomic, assign) NSInteger fromWitchVC; // 2 添加好友


@end
