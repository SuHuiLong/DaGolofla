//
//  SearchWIthCityModel.m
//  DagolfLa
//
//  Created by SHL on 2017/5/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SearchWIthCityModel.h"
#import "SearchWithCityDetailModel.h"
@implementation SearchWIthCityModel

-(void)setProvinceList:(NSArray *)provinceList{
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSDictionary *dict in provinceList) {
        SearchWithCityDetailModel *model = [SearchWithCityDetailModel modelWithDictionary:dict];
        [mArray addObject:model];
    }
    _provinceList = mArray;
}

@end
