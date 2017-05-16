//
//  JGHMatchTranscriptTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHMatchTranscriptTableViewCellDelegate <NSObject>

- (void)selectSetAlmostBtn;

@end

@interface JGHMatchTranscriptTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *ballName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballNameLeft;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballNameTop;//15

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballNameRight;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeImageLeft;//10

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeRight;//10

@property (weak, nonatomic) IBOutlet UIButton *setAlmostBtn;
- (IBAction)setAlmostBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setAlmostBtnRight;//10

@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTop;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneTop;//10

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *totalLable;
@property (weak, nonatomic) IBOutlet UILabel *almostLable;
@property (weak, nonatomic) IBOutlet UILabel *netBarLable;


@property (nonatomic, weak)id <JGHMatchTranscriptTableViewCellDelegate> delegate;

- (void)configActivityName:(NSString *)name andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime;


@end
