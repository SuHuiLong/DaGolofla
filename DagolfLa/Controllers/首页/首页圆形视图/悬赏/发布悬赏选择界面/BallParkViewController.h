//
//  BallParkViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/12.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface BallParkViewController : ViewController
@property(nonatomic,assign)NSInteger type1;
@property (nonatomic,copy) void(^callback)(NSString *,NSInteger);
@property (nonatomic,copy) void(^callback1)(NSDictionary *dict);
@end
