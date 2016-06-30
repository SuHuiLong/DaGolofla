//
//  JGHSelectBlanKCardView.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JGHSelectBlanKCardViewDelegate <NSObject>

- (void)seleCancelBtn:(UIButton *)btn;

- (void)selectSubmitBtn:(UIButton *)btn;

@end

@interface JGHSelectBlanKCardView : UIView

@property (nonatomic, weak)id <JGHSelectBlanKCardViewDelegate> delegate;

- (void)configViewData:(NSMutableArray *)array;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end
