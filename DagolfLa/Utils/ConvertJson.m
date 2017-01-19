//
//  ConvertJson.m
//  TourismAP
//
//  Created by bst on 15/11/20.
//  Copyright © 2015年 HuangDM. All rights reserved.
//

#import "ConvertJson.h"

@implementation ConvertJson


#pragma mark - JSON Convert
+ (NSDictionary *)convertJSONToDict:(NSString *)string
{
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!data || data == nil) {
        return nil;
    }
    NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (nil == error){
        return respDict;
    }else{
        return nil;
    }
}

+ (NSArray *)convertJSONToArray:(NSString *)string
{
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!data || data == nil) {
        return nil;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (nil == error){
        return array;
    }else{
        return nil;
    }
}

@end
