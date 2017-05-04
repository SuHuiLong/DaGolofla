//
//  JGHHistoryScoreView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGDHistoryScoreModel;

@interface JGHHistoryScoreView : UIView

@property (nonatomic, strong) UISearchController *searchController;

@property (copy, nonatomic) void (^blockSelectHistoryScore)(JGDHistoryScoreModel *);

@property (copy, nonatomic) void (^blockSelectHistoryScoreAlert)(UIAlertController *);

@property (nonatomic, strong) UITableView *tableView;

//数据源
@property (nonatomic, strong) NSMutableArray *dataArray;


//每次进入刷新数据
- (void)refreshData;

@end
