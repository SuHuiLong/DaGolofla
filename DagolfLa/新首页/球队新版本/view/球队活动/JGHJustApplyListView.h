//
//  JGHJustApplyListView.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHJustApplyListViewDelegate <NSObject>

- (void)didJustApplyListCancelBtn:(UIButton *)btn;

- (void)didJustApplyListApplyBtn:(UIButton *)btn;

@end

@interface JGHJustApplyListView : UIView

@property (nonatomic, strong)NSMutableArray *justApplistArray;

@property (nonatomic, weak)id <JGHJustApplyListViewDelegate> delegate;

- (void)configjustApplyViewData:(NSMutableArray *)array;


@end
