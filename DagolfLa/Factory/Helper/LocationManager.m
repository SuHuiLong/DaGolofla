//
//  LocationManager.m
//  LimitFree
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 PengFei.Shan. All rights reserved.
//

#import "LocationManager.h"
//单例所指向的内存区域，整个App进程只有一次初始化
static LocationManager *manager = nil;

@implementation LocationManager
+ (LocationManager *)shareSingleton {
    @synchronized (self) {
        if (!manager) {
            manager = [[LocationManager alloc] init];
        }
    }
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        //系统的定位管理器
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        //定位精度
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        //请求授权
        [self.manager requestAlwaysAuthorization];
    }
    return self;
}

/*
 针对系统定位的顶层封装的好处
 1、子视图控制器或其他组件可以用更少的代码完成对应的工作
 2、底层内容或者调用改变，只需要改变中间的封层，对于各个组件并无影响。
 [LocationManager getUserLocation:^(CLLocation *location) {
 
 }];
 */
+ (void)getUserLocation:(GetLocationInformation)block {
    if (!manager) {
        manager = [LocationManager shareSingleton];
    }
    manager.callback = block;
    [manager.manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _callback([locations lastObject]);
    [manager stopUpdatingLocation];
}
@end
