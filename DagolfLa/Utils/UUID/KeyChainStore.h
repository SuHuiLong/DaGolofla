//
//  KeyChainStore.h
//  TestUUID
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 com.huangDM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end
