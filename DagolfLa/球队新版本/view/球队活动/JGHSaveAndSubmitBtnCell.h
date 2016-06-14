//
//  JGHSaveAndSubmitBtnCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHSaveAndSubmitBtnCellDelegate <NSObject>

- (void)SaveBtnClick:(UIButton *)btn;

- (void)SubmitBtnClick:(UIButton *)btn;

@end

@interface JGHSaveAndSubmitBtnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)saveBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitBtn:(UIButton *)sender;

@property (weak, nonatomic)id <JGHSaveAndSubmitBtnCellDelegate> delegate;

@end
