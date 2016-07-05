//
//  JGHChooseAwardCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHChooseAwardCellDelegate <NSObject>

- (void)selectChooseAwardBtnClick:(UIButton *)btn;

@end

@interface JGHChooseAwardCell : UITableViewCell

@property (nonatomic, weak)id <JGHChooseAwardCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiangbeiLeft;

@property (weak, nonatomic) IBOutlet UILabel *awardName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awardNameLeft;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseBtnRight;


- (IBAction)chooseBtnClick:(UIButton *)sender;

- (void)config;

@end
