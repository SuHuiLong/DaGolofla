//
//  MakePhotoTextViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/3/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"

@interface MakePhotoTextViewController : BaseViewController
//数据源
@property(nonatomic, strong)NSMutableArray *dataArray;
//球队名
@property(nonatomic, copy)NSString *teamName;
//球队key
@property(nonatomic, copy)NSNumber *teamTimeKey;
@end
