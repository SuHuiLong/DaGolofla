//
//  JGTeamActivityCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;

@interface JGTeamActivityCell : UITableViewCell
//活动列表标题
@property (weak, nonatomic) IBOutlet UILabel *activitytitle;
//报名
@property (weak, nonatomic) IBOutlet UILabel *Apply;
//活动时间
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
//活动地址
@property (weak, nonatomic) IBOutlet UILabel *activityAddress;
//报名人数
@property (weak, nonatomic) IBOutlet UILabel *applyNumber;
@property (weak, nonatomic) IBOutlet UILabel *maxCount;

//imageView
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
//activityStateImage
@property (weak, nonatomic) IBOutlet UIImageView *activityStateImage;

//填充cell数据

- (void)setJGTeamActivityCellWithModel:(JGTeamAcitivtyModel *)modeel fromCtrl:(NSInteger)ctrlId;

@end
