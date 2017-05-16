//
//  SearchWithCityViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/5/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchWithCityViewController : BaseViewController


/**
 选中城市的block
 */
@property (copy, nonatomic) void (^blockAddress)(NSString* city);

/**
 请求类型 0：订场城市选择 1：活动城市选择
 */
@property (nonatomic,assign) NSInteger requestType;
@end
