//
//  JGHNavListView.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNavListViewDelegate <NSObject>

- (void)didSelectMyTeamBtn:(UIButton *)btn;

- (void)didSelectStartScoreBtn:(UIButton *)btn;

- (void)didSelectHistoryResultsBtn:(UIButton *)btn;

- (void)didSelectShitaBtn:(UIButton *)btn;

@end

@interface JGHNavListView : UIView

@property (weak, nonatomic)id <JGHNavListViewDelegate> delegate;

@property (nonatomic, strong) UIButton *teamBtn;
@property (nonatomic, strong) UILabel *teamLable;

@property (nonatomic, strong) UIButton *scoreBtn;
@property (nonatomic, strong) UILabel *scoreLable;

@property (nonatomic, strong) UIButton *resultsBtn;
@property (nonatomic, strong) UILabel *resultsLable;

@end
