//
//  JGHSimpleAndResultsCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHSimpleAndResultsCellDelegate <NSObject>

- (void)selectSimpleScoreBtnClick:(UIButton *)btn;

- (void)selectHoleScoreBtnClick:(UIButton *)btn;

@end

@interface JGHSimpleAndResultsCell : UITableViewCell

@property (nonatomic, weak)id <JGHSimpleAndResultsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;//10

@property (weak, nonatomic) IBOutlet UIButton *simpleScoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *simpleScoreBtnRight;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *simpleScoreBtnW;//80
- (IBAction)simpleScoreBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *holeScoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holeScoreBtnRight;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holeScoreBtnW;
- (IBAction)holeScoreBtnClick:(UIButton *)sender;

- (void)configUIBtn:(NSInteger)btnId;

@end
