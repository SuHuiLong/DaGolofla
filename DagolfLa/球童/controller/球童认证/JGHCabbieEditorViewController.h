//
//  JGHCabbieEditorViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGHCaddieAuthModel;

@interface JGHCabbieEditorViewController : ViewController

@property (nonatomic, strong)JGHCaddieAuthModel *model;

@property (strong, nonatomic) void (^refreshBlock)();

@end
