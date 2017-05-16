//
//  JGHAreaListView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHAreaListViewDelegate <NSObject>

- (void)areaString:(NSString *)areaString andID:(NSInteger)selectId;

@end

@interface JGHAreaListView : UIView


@property (nonatomic, weak)id <JGHAreaListViewDelegate> delegate;

@property (nonatomic, strong)UITableView *listTableView;

@property (nonatomic, strong)NSArray *listArray;

- (void)reloadAreaListView:(NSArray *)listArray andCurrAreString:(NSString *)areString;

@property (nonatomic, retain)UILabel *twoLine;

@end
