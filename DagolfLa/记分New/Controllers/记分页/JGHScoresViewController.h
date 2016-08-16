//
//  JGHScoresViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHScoresViewController : UIViewController

@property (nonatomic, strong)NSString *scorekey;


@property (nonatomic, assign)NSInteger backId;//1-记分

@property (nonatomic, assign)NSInteger currentPage;

@property (nonatomic, assign)NSInteger isCabbie;//1-球童

@property (strong, nonatomic) void (^refreshBlock)();

@end
