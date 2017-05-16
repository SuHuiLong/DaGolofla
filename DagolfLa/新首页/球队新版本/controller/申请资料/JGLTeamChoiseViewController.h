//
//  JGLTeamChoiseViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLTeamChoiseViewController : ViewController

//存放数据源的数组
@property (strong, nonatomic) NSArray* dataArray;
//BLOCK
@property (copy, nonatomic) void(^introBlock)(NSString *, NSNumber* );


@end
