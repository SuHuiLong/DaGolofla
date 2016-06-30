//
//  JGHRepeatApplyView.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHRepeatApplyViewDelegate <NSObject>

- (void)selectCancelRepeatApply:(UIButton *)btn;

- (void)selectRepeatApply:(UIButton *)btn;

@end

@interface JGHRepeatApplyView : UIView

@property (nonatomic, strong)NSMutableArray *repeatAppArray;

@property (weak, nonatomic)id <JGHRepeatApplyViewDelegate> delegate;

- (void)configViewData:(NSMutableArray *)array;

@property (nonatomic, assign)float subsidiesPrice;//补贴金额



@end
