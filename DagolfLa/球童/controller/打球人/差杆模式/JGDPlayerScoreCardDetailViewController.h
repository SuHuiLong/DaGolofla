//
//  JGDPlayerScoreCardDetailViewController.h
//  DagolfLa
//
//  Created by 東 on 16/9/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGDHistoryScoreShowModel.h"

@interface JGDPlayerScoreCardDetailViewController : ViewController

@property (nonatomic, strong) JGDHistoryScoreShowModel *model;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, assign) NSInteger fromLive; // 从直播进入 5
@property (nonatomic, strong) NSNumber *srcKey;
@property (nonatomic, strong) NSNumber *scoreKey;
@property (nonatomic, assign) NSInteger ballkid;
@property (nonatomic, strong) NSNumber *isReversal;

@end
