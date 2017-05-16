//
//  DicoveryMapViewViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^blockProvince)(NSString *province);
@interface DicoveryMapViewViewController : BaseViewController

//选择城市名
@property(nonatomic, copy)NSString *cityName;
/**
 选中城市的block
 */
@property (copy, nonatomic) blockProvince blockProvince;


@end
