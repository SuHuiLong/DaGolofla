//
//  DateTimeViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/11.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface DateTimeViewController : ViewController

@property (nonatomic,copy) void(^callback)(NSString *,NSString *, NSString *);


@property (strong, nonatomic) NSNumber* typeIndex;

@end
