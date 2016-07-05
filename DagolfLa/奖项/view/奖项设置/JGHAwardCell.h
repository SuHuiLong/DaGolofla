//
//  JGHAwardCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHAwardModel;

@protocol JGHAwardCellDelegate <NSObject>

- (void)selectAwardDeleBtn:(UIButton *)btn;

- (void)selectAwardEditorBtn:(UIButton *)btn;

@end

@interface JGHAwardCell : UITableViewCell

@property (nonatomic, weak)id <JGHAwardCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiangbeiLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiangbeiTop;


@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;


@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
- (IBAction)deleBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleBtnRight;

@property (weak, nonatomic) IBOutlet UIButton *editorBtn;
- (IBAction)editorBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editorBtnRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bluequanTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bluequanLeft;


@property (weak, nonatomic) IBOutlet UILabel *award;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awardLeft;

@property (weak, nonatomic) IBOutlet UILabel *awardNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awardNumberLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awardNumberRight;


- (void)configJGHAwardModel:(JGHAwardModel *)model;


@end
