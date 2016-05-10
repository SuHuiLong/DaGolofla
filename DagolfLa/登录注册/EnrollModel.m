//
//  EnrollModel.m
//  DaGolfla
//
//  Created by bhxx on 15/9/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "EnrollModel.h"

@implementation EnrollModel




+(NSMutableArray *)parsingWithJSONData:(NSData *)data
{
    NSMutableArray *resArr = [[NSMutableArray alloc]init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    ////NSLog(@"dic===================%@",dic);
    NSArray *arr = dic[@"rows"];
    for (NSDictionary *subdic in arr) {
        EnrollModel *model = [[EnrollModel alloc]init];
        //KVC赋值
        [model setValuesForKeysWithDictionary:subdic];
        [resArr addObject:model];
        
    }
    return resArr;
}





@end
