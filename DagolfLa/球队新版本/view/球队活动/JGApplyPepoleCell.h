//
//  JGApplyPepoleCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGApplyPepoleCellDelegate <NSObject>

- (void)addApplyPeopleClick;

@end

@interface JGApplyPepoleCell : UITableViewCell
//添加活动嘉宾
- (IBAction)addApplyBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *addApplyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *directionImageView;

@property (weak, nonatomic)id <JGApplyPepoleCellDelegate> delegate;
@end
