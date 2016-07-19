//
//  JGHScoresHoleCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHScoresHoleCellDelegate <NSObject>

- (void)selectHoleCoresBtnTag:(NSInteger)btnTag andCellTag:(NSInteger)cellTag;

@end

@interface JGHScoresHoleCell : UITableViewCell

@property (nonatomic, weak)id <JGHScoresHoleCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *one;
- (IBAction)oneBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *two;
- (IBAction)twoBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *three;
- (IBAction)threeBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *four;
- (IBAction)fourBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *five;
- (IBAction)fiveBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *six;
- (IBAction)sixBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *seven;
- (IBAction)sevenBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *eight;
- (IBAction)eightBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *nine;
- (IBAction)nineBtnClick:(UIButton *)sender;

#pragma mark -- 设置颜色
- (void)configAllViewBgColor:(NSString *)colorString;

- (void)configArray:(NSArray *)array;

@end
