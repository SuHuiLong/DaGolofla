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

//@property (nonatomic, strong)NSMutableArray *ballBaseArray;//请求参数

@property (nonatomic, strong)NSString *rulesTimeKey;//规则key

@property (nonatomic, strong)NSMutableArray *roundArray;//赛制Array

@property (nonatomic, assign)NSInteger ballKey;//球场KEY

@property (nonatomic, strong)NSString *ballName;//球场名称

@property (nonatomic, strong)NSString *beginDate;//开球时间

@end
