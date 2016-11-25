//
//  NewFriendModel.m
//  DagolfLa
//
//  Created by bhxx on 16/3/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "NewFriendModel.h"

@implementation NewFriendModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"userKey"]) {
        [super setValue:value forKey:@"userId"];
        
    }else{
        [super setValue:value forKey:key];
    }
}


@end
