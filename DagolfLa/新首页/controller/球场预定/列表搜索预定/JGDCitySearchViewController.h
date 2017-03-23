//
//  JGDCitySearchViewController.h
//  DagolfLa
//
//  Created by 東 on 16/12/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGDCitySearchViewController : ViewController

@property (copy, nonatomic) void (^blockAddress)(NSString* city);

@end
