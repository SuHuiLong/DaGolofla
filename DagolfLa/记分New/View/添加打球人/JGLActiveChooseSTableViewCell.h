//
//  JGLActiveChooseSTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLAddActiivePlayModel;

@protocol JGLActiveChooseSTableViewCellDelegate <NSObject>

- (void)deleteActivityScorePlayrBtn:(UIButton *)btn;

@end

@interface JGLActiveChooseSTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel* labelTitle;

@property (strong, nonatomic) UIButton* deleteBtn;

@property (nonatomic, weak)id <JGLActiveChooseSTableViewCellDelegate> delegate;


- (void)configJGLAddActiivePlayModel:(JGLAddActiivePlayModel *)model;


@end
