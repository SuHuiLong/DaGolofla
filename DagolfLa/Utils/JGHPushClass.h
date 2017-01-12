//
//  JGHPushClass.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PushClass)(UIViewController *vc);

@interface JGHPushClass : NSObject

+ (instancetype)pushClass;

- (void)URLString:(NSString *)urlString pushVC:(PushClass)pushVC;

@end
