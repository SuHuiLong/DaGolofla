//
//  JGHAddMoreTeamTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHAddMoreTeamTableViewCellDelegate <NSObject>

- (void)didSelectAddMoreBtn:(UIButton *)btn;

@end

@interface JGHAddMoreTeamTableViewCell : UITableViewCell

@property (weak, nonatomic)id <JGHAddMoreTeamTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *addTeamBtn;

@property (nonatomic, strong)UIButton *allBtn;


@end
