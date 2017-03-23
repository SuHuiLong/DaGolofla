//
//  ShowMapViewViewController.h
//  DagolfLa
//
//  Created by 张天宇 on 15/10/14.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "ViewController.h"
@interface ShowMapViewViewController : ViewController


@property (nonatomic, strong) NSMutableArray *mapCLLocationCoordinate2DArr;
//是否联盟球场
@property (nonatomic, assign) BOOL isLeague;

@property (nonatomic, assign) NSInteger fromWitchVC;  // 1 球场

@end
