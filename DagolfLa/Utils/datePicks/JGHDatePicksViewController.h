//
//  JGHDatePicksViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHDatePicksViewController : ViewController

@property (nonatomic, copy)void (^returnDateString)(NSString *dateString);

@end
