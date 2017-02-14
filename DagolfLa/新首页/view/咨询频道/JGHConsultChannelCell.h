//
//  JGHConsultChannelCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHConsultChannelCellDelegate <NSObject>

- (void)didSelectJGHConsultChannelCellBtnClick:(UIButton *)btn;

@end

@interface JGHConsultChannelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *eventBtn;
- (IBAction)eventBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *skillBtn;
- (IBAction)skillBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
- (IBAction)activityBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
- (IBAction)videoBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *oneLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLineDown;

@property (weak, nonatomic) IBOutlet UILabel *twoLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLineDown;

@property (weak, nonatomic) IBOutlet UILabel *threeLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLineDown;


@property (weak, nonatomic)id <JGHConsultChannelCellDelegate> delegate;

- (void)configJGHConsultChannelCell:(NSInteger)showId;

@end
