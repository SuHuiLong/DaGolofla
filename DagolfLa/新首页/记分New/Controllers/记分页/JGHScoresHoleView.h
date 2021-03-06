//
//  JGHScoresHoleView.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHScoresHoleViewDelegate <NSObject>

- (void)scoresHoleViewDelegateCloseBtnClick:(UIButton *)btn;

- (void)oneAreaString:(NSString *)areaString andID:(NSInteger)selectId;

@end

@interface JGHScoresHoleView : UIView

@property (weak, nonatomic)id <JGHScoresHoleViewDelegate> delegate;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, assign)NSInteger curPage;

@property (nonatomic, strong)NSString *scorekey;

- (void)reloadScoreList:(NSArray *)currentAreaArray andAreaArray:(NSArray *)areaArray;

//选择区域后－－刷新试图数据
- (void)reloadViewData:(NSMutableArray *)dataArray andCurrentAreaArrat:(NSArray *)currentAreaArray;

@end
