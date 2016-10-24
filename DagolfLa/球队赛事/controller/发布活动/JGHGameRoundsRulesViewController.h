//
//  JGHGameRoundsRulesViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHGameRoundsRulesViewControllerDelegate <NSObject>

- (void)didGameRoundsRulesViewSaveroundRulesArray:(NSMutableArray *)roundRulesArray;

@end

@interface JGHGameRoundsRulesViewController : ViewController

@property (nonatomic, strong)NSMutableArray *roundRulesArray;//保存的规则

@property (nonatomic, strong)NSString *rulesTimeKey;

@property (nonatomic, strong)id <JGHGameRoundsRulesViewControllerDelegate> delegate;

@end
