//
//  JGHGameSetCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHGameSetCellDelegate <NSObject>

- (void)didSelectJGHGameSetCellBtn:(UIButton *)btn;

@end

@interface JGHGameSetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *gameSet;//16
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameSetLeft;//25

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;//35

- (IBAction)gameSetCellBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *gameSetCellBtn;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downImageViewRight;//15

@property (weak, nonatomic)id <JGHGameSetCellDelegate> delegate;

- (void)configJGHGameSetCellTitleString:(NSString *)titleString andSelect:(NSInteger)select;


@end
