//
//  TabBarController.h
//  爱限免
//
//  Created by huangdl on 15-5-4.
//  Copyright (c) 2015年 黄驿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController

+ (TabBarController *)shareInstance;

@property (nonatomic, assign) NSUInteger selectedTabBarIndex;

@end
