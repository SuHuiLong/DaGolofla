//
//  JGHScoresHoleView.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHScoresHoleView : UIView

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, assign)NSInteger curPage;

- (void)reloadScoreList;

@end
