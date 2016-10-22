//
//  JGHGameSetViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHGameSetViewControllerDelegate <NSObject>

- (void)saveRulesArray:(NSMutableArray *)rulesArray;

@end

@interface JGHGameSetViewController : ViewController

@property (nonatomic, strong)NSMutableArray *rulesArray;

@property (weak, nonatomic)id <JGHGameSetViewControllerDelegate> delegate;

@end
