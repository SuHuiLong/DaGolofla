//
//  JGHGameBaseSetViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHGameBaseSetViewControllerDelegate <NSObject>

- (void)selectRulesArray:(NSMutableArray *)rulesArray;

@end

@interface JGHGameBaseSetViewController : ViewController

@property (weak, nonatomic)id <JGHGameBaseSetViewControllerDelegate> delegate;

@property (nonatomic, strong)NSMutableDictionary *dictData;

@property (nonatomic, strong)NSMutableArray *rulesArray;

@property (nonatomic, assign)NSInteger rulesId;//设置的规则ID  （序号）


@end
