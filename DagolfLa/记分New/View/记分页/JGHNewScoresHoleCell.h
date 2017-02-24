//
//  JGHNewScoresHoleCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/23.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewScoresHoleCellDelegate <NSObject>

- (void)selectHoleCoresBtnTag:(NSInteger)btnTag andCellTag:(NSInteger)cellTag;

@end

@interface JGHNewScoresHoleCell : UITableViewCell

@property (nonatomic, weak)id <JGHNewScoresHoleCellDelegate> delegate;

@property (strong, nonatomic)UIView *bgView;

@property (strong, nonatomic) UILabel *Taiwan;

@property (strong, nonatomic) UILabel *bgLable;

@property (strong, nonatomic) UILabel *name;

@property (strong, nonatomic) UIButton *one;
@property (strong, nonatomic) UIButton *two;
@property (strong, nonatomic) UIButton *three;
@property (strong, nonatomic) UIButton *four;
@property (strong, nonatomic) UIButton *five;
@property (strong, nonatomic) UIButton *six;
@property (strong, nonatomic) UIButton *seven;
@property (strong, nonatomic) UIButton *eight;
@property (strong, nonatomic) UIButton *nine;

@property (strong, nonatomic)UILabel *oneLable;
@property (strong, nonatomic)UILabel *twoLable;
@property (strong, nonatomic)UILabel *threeLable;
@property (strong, nonatomic)UILabel *fourLable;
@property (strong, nonatomic)UILabel *fiveLable;
@property (strong, nonatomic)UILabel *sixLable;
@property (strong, nonatomic)UILabel *sevenLable;
@property (strong, nonatomic)UILabel *eightLable;
@property (strong, nonatomic)UILabel *nineLable;

#pragma mark -- 设置颜色
- (void)configAllViewBgColor:(NSString *)colorString andCellTag:(NSInteger)tag;
- (void)configOneToNine:(NSArray *)array andUserName:(NSString *)userName;//标准杆
- (void)configNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName;//biao
//总杆模式
- (void)configArray:(NSArray *)array;

- (void)configOneToNine:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray andTaiwan:(NSString *)taiwan;//计算杆的属性

- (void)configNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray andTaiwan:(NSString *)taiwan;//计算杆的属性

//差杆模式
- (void)configPoorArray:(NSArray *)array;

- (void)configPoorOneToNine:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray andTaiwan:(NSString *)taiwan;

- (void)configPoorNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray andTaiwan:(NSString *)taiwan;//计算杆的属性

@end
