//
//  ConvertJson.h
//  TourismAP
//
//  Created by bst on 15/11/20.
//  Copyright © 2015年 HuangDM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertJson : NSObject

+ (NSDictionary *)convertJSONToDict:(NSString *)string;


+ (NSArray *)convertJSONToArray:(NSString *)string;


@end
