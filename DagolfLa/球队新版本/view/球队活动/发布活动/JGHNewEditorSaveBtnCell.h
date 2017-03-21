//
//  JGHNewEditorSaveBtnCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewEditorSaveBtnCellDelegate <NSObject>

- (void)editonAttendBtnClick:(UIButton *)saveBtn;

@end

@interface JGHNewEditorSaveBtnCell : UITableViewCell

@property (nonatomic, weak)id <JGHNewEditorSaveBtnCellDelegate> delegate;

@property (nonatomic, strong)UIButton *saveBtn;

- (void)configJGHNewEditorSaveBtnCell:(BOOL)edtior;

@end
