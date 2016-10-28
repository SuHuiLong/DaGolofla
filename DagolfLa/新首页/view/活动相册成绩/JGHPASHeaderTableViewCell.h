//
//  JGHPASHeaderTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHPASHeaderTableViewCellDelegate <NSObject>

- (void)didSelectActivityOrPhotoOrResultsBtn:(UIButton *)btn;

@end

@interface JGHPASHeaderTableViewCell : UITableViewCell

@property (nonatomic, weak)id <JGHPASHeaderTableViewCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
- (IBAction)activityBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *activityLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityLableW;//40

@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
- (IBAction)photoBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *photoLable;

@property (weak, nonatomic) IBOutlet UIButton *resultsBtn;
- (IBAction)resultsBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *resultsLable;


- (void)configJGHPASHeaderTableViewCell:(NSInteger)showId;

@end
