//
//  JGHLoginViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHLoginViewController : ViewController

typedef void(^ReloadCtrlData)();
@property(nonatomic,copy)ReloadCtrlData reloadCtrlData;

@property (nonatomic, assign)NSInteger index;

@end
