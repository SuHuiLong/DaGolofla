//
//  JGHBtnCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHBtnCellDelegate <NSObject>

- (void)commitCabbieCert:(UIButton *)btn;

@end

@interface JGHBtnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
- (IBAction)titleBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnRight;

@property (nonatomic, weak)id <JGHBtnCellDelegate> delegate;

- (void)configBtn;

- (void)configSuccessBtn;

- (void)configStartBtn;

- (void)configNextBtn;

- (void)configEventNextBtn;

@end
