//
//  JGHNewActivitySaveAndPublishCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewActivitySaveAndPublishCellDelegate <NSObject>

- (void)SaveBtnClick:(UIButton *)saveBtn;

- (void)SubmitBtnClick:(UIButton *)submitBtn;

@end

@interface JGHNewActivitySaveAndPublishCell : UITableViewCell

@property (weak, nonatomic)id <JGHNewActivitySaveAndPublishCellDelegate> delegate;

@property (nonatomic, strong)UIButton *saceBtn;

@property (nonatomic, strong)UIButton *publishBtn;

@property (nonatomic, strong)UIView *bgView;

@end
