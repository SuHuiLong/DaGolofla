//
//  JGLAddActivePlayViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLChooseScoreModel.h"

@interface JGLAddActivePlayViewController : ViewController

@property (strong, nonatomic) JGLChooseScoreModel* model;

@property (retain, nonatomic) NSMutableArray *palyArray;

@property (assign, nonatomic)NSInteger iscabblie;//0-非球童;1-球童
@property (strong, nonatomic)NSNumber *userKeyPlayer;//球童扫描的打球人Key

@property (copy, nonatomic) void (^blockSurePlayer)( NSMutableArray *);

@end
