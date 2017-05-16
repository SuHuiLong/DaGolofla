//
//  JGHNewPoorBarHoleCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewPoorBarHoleCellDelegate <NSObject>

- (void)selectNewPoorAreaBtnClick:(UIButton *)btn andCurrtitle:(NSString *)currtitle;

@end

@interface JGHNewPoorBarHoleCell : UITableViewCell

@property (nonatomic, retain)UILabel *nameLable;

@property (nonatomic, retain)UIButton *arebtn;

@property (nonatomic, retain)UIButton *poorBtn;

@property (weak, nonatomic)id <JGHNewPoorBarHoleCellDelegate> delegate;


- (void)configJGHNewPoorBarHoleCell:(NSString *)boor;

@end
