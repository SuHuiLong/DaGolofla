//
//  JGTeamActivityDetailsCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGTeamActivityDetailsCell : UITableViewCell
//活动详情
@property (weak, nonatomic) IBOutlet UILabel *details;
//活动详情内容
@property (weak, nonatomic) IBOutlet UILabel *activityDetails;

- (void)configDetailsText:(NSString *)details AndActivityDetailsText:(NSString *)activityDetails;

@end
