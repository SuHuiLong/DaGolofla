//
//  JGHPoorScoreHoleView.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHPoorScoreHoleViewDelegate <NSObject>

- (void)oneAreaPoorBtnDelegate:(UIButton *)btn;

- (void)twoAreaPoorBtnDelegate:(UIButton *)btn;

@end

@interface JGHPoorScoreHoleView : UIView

@property (weak, nonatomic)id <JGHPoorScoreHoleViewDelegate> delegate;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, assign)NSInteger curPage;

@property (nonatomic, strong)NSArray *areaArray;//球道区域

//@property (nonatomic, strong)NSArray *twoAreaArray;//球道区域

- (void)reloadScoreList;

- (void)removePoorOneAreaView;

- (void)removePoorTwoAreaView;

//选择区域后－－刷新试图数据
- (void)reloadPoorViewData:(NSMutableArray *)dataArray;

@end
