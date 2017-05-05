//
//  SearchWIthCityModel.h
//  DagolfLa
//
//  Created by SHL on 2017/5/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchWIthCityModel : NSObject
/**
 区域
 */
@property (nonatomic,copy) NSString *areaName;

/**
 城市列表和球场数
 */
@property (nonatomic,copy) NSArray *provinceList;

@end
