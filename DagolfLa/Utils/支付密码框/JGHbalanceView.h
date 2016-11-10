//
//  JGHbalanceView.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHbalanceViewDelegate <NSObject>

- (void)deleteBalanceView:(UIButton *)btn;

@end

@interface JGHbalanceView : UIView

@property (nonatomic, weak)id <JGHbalanceViewDelegate> delegate;

@property (nonatomic, strong)UIButton *delebtn;

@property (nonatomic, strong)UILabel *price;

@property (nonatomic, strong)UILabel *balance;

@end
