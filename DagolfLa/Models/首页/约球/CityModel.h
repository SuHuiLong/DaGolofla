//
//  CityModel.h
//  DaGolfla
//
//  Created by bhxx on 15/10/6.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface CityModel : BaseModel

@property (copy, nonatomic) NSNumber* region_ID;
@property (copy, nonatomic) NSString* region_CODE;
@property (copy, nonatomic) NSString* region_NAME;
@property (copy, nonatomic) NSNumber* parent_ID, *region_LEVEL, *region_ORDER;
@property (copy, nonatomic) NSString* region_NAME_EN;
@property (copy, nonatomic) NSString* region_SHORTNAME_EN;

@end
/*
{
    "rows":
    [{
        "region_ID":378,
        "region_CODE":"110101",
        "region_NAME":"东城区",
        "parent_ID":33,
        "region_LEVEL":0,
        "region_ORDER":0,
        "region_NAME_EN":"Dongcheng Qu",
        "region_SHORTNAME_EN":"DCQ"
    },
    {
        "region_ID":379,
        "region_CODE":"110102",
        "region_NAME":"西城区",
        "parent_ID":33,
        "region_LEVEL":0,
        "region_ORDER":0,
        "region_NAME_EN":"Xicheng Qu",
        "region_SHORTNAME_EN":"XCQ"
    },
     
    ],
    "message":"查询成功",
    "success":true,
    "total":0,
    "flg":0
}
*/