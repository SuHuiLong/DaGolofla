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
//球场名称
@property (weak, nonatomic) IBOutlet UILabel *reamName;
//活动时间
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
//人员限制
@property (weak, nonatomic) IBOutlet UILabel *limits;

- (void)configModel:(JGTeamAcitivtyModel *)model;

@end
