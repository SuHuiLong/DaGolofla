//
//  JGHGameRoundsViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHGameRoundsViewController : ViewController

//@property (nonatomic, strong)NSMutableArray *rulesArray;

@property (nonatomic, assign)NSInteger timeKey;//赛事key

@property (nonatomic, strong)NSMutableArray *ballBaseArray;//请求参数

@property (nonatomic, strong)NSString *rulesTimeKey;//规则key

@property (nonatomic, strong)NSMutableArray *roundArray;//赛制Array

@end
