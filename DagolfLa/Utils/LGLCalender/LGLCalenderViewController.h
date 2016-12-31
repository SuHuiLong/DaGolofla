//
//  LGLCalenderViewController.h
//  LGLProgress
//
//  Created by 李国良 on 2016/10/11.
//  Copyright © 2016年 李国良. All rights reserved.
//  https://github.com/liguoliangiOS/LGLCalender.git

#import "ViewController.h"

typedef void(^SelectDateBalock)(NSMutableDictionary * paramas);

@interface LGLCalenderViewController : ViewController

@property (copy, nonatomic) void (^blockTimeWeekPriceDict)(NSDictionary *);

//@property (nonatomic, copy) SelectDateBalock block;
//- (void)seleDateWithBlock:(SelectDateBalock)block;

@end
