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

@end
