//
//  JGDHistoryScoreModel.m
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDHistoryScoreModel.h"

@implementation JGDHistoryScoreModel


- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"name"]) {
        [super setValue:value forKey:@"title"];
        
    } else if ([key isEqualToString:@"beginDate"]) {
        [super setValue:value forKey:@"createtime"];
        
    } else{
        [super setValue:value forKey:key];
    }
}


@end
