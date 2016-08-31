//
//  JGHApplyListView.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHApplyListViewDelegate <NSObject>

- (void)didSelectCancelBtn:(UIButton *)btn;

- (void)didSelectPayBtn:(UIButton *)btn andApplyListArray:(NSMutableArray *)applistArray;


@end

@interface JGHApplyListView : UIView

@property (nonatomic, strong)NSMutableArray *applistArray;

@property (weak, nonatomic)id <JGHApplyListViewDelegate> delegate;

- (void)configViewData:(NSMutableArray *)array andCanSubsidy:(NSInteger)canSubsidy;

@property (nonatomic, assign)float subsidiesPrice;//补贴金额

@property (assign, nonatomic)NSInteger canSubsidy;//是否可以补贴0-不，1-补贴

@end
