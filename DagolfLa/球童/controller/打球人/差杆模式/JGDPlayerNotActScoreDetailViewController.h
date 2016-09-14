//
//  JGDPlayerNotActScoreDetailViewController.h
//  DagolfLa
//
//  Created by 東 on 16/9/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGDHistoryScoreShowModel.h"

@interface JGDPlayerNotActScoreDetailViewController : ViewController

@property (nonatomic, strong) JGDHistoryScoreShowModel *model;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, assign) NSInteger ballkid;
@property (nonatomic, strong) NSNumber *isReversal;

@end
