//
//  BallParkViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/12.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
@interface BallParkViewController : ViewController
@property(nonatomic,assign)NSInteger type1;
@property (nonatomic,copy) void(^callback)(NSString *,NSInteger);
@property (nonatomic,copy) void(^callback1)(NSDictionary *dict, NSString*);//返回球场所需参数


@property (assign, nonatomic) BOOL isNeedAdd;//是否需要球场的block
@property (nonatomic,copy) void(^callbackAddress)(NSString *,NSInteger, NSString*);
@end
