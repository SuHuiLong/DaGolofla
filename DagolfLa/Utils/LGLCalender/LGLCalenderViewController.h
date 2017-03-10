//
//  LGLCalenderViewController.h
//  LGLProgress
//
//  Created by 李国良 on 2016/10/11.
//  Copyright © 2016年 李国良. All rights reserved.
//  https://github.com/liguoliangiOS/LGLCalender.git

#import "ViewController.h"

//typedef void(^SelectDateBalock)(NSMutableDictionary * paramas);

@interface LGLCalenderViewController : ViewController

@property (nonatomic, retain)NSNumber *ballKey;
@property (nonatomic, assign) BOOL isLeagueUser; // YES 是联盟会员  NO 非联盟会员

@property (copy, nonatomic) void (^blockTimeWithPrice)(NSString *, NSString *, NSString *, NSString *, NSString *);//时间、价格、线下支付价格、联盟价格

//@property (nonatomic, copy) SelectDateBalock block;
//- (void)seleDateWithBlock:(SelectDateBalock)block;

@end
