//
//  JGHScoresMainViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface JGHScoresMainViewController : UIViewController

@property (nonatomic,assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy)void (^returnScoresDataArray)(NSMutableArray *dataArray);

@end
