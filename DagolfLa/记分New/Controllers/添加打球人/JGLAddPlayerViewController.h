//
//  JGLAddPlayerViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLAddPlayerViewController : ViewController


@property (copy, nonatomic) void (^blockSurePlayer)(NSMutableDictionary *);

@property (copy, nonatomic) NSMutableDictionary* dictFin,* dictPeople;
;

@end
