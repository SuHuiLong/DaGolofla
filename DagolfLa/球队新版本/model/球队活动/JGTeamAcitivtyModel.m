//
//  JGTeamAcitivtyModel.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamAcitivtyModel.h"

@implementation JGTeamAcitivtyModel

- (void)setValue:(id)value forKey:(NSString *)key{
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"title"]) {
        [self setValue:value forKey:@"name"];
    }
}

@end
