//
//  JGDTeamShowTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 16/8/3.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGDHistoryScoreShowModel.h"

@interface JGDTeamShowTableViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *colorImageV;

@property (nonatomic, strong) UILabel *nameLB;

@property (nonatomic, strong) UILabel *sumLB;

- (void)takeInfoWithModel:(JGDHistoryScoreShowModel *)model index:(NSIndexPath *)indexPath;

- (void)takeDetailInfoWithModel:(JGDHistoryScoreShowModel *)model index:(NSIndexPath *)indexPath;

@end
