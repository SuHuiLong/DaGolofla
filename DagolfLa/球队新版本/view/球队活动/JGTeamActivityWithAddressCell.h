//
//  JGTeamActivityWithAddressCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;

@interface JGTeamActivityWithAddressCell : UITableViewCell
//开始时间
@property (weak, nonatomic) IBOutlet UILabel *reamName;
//结束时间
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
//截止时间
@property (weak, nonatomic) IBOutlet UILabel *limits;

- (void)configModel:(JGTeamAcitivtyModel *)model;

@end
