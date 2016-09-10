//
//  JGDAlmostScoreTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 16/9/6.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGDHistoryScoreShowModel.h"

@interface JGDAlmostScoreTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *colorImageV;

@property (nonatomic, strong) UILabel *nameLB;

@property (nonatomic, strong) UILabel *sumLB;

- (void)takeInfoWithModel:(JGDHistoryScoreShowModel *)model index:(NSIndexPath *)indexPath;

- (void)takeDetailInfoWithModel:(JGDHistoryScoreShowModel *)model index:(NSIndexPath *)indexPath;


// 设置洞数

- (void)setholeSWithModel:(JGDHistoryScoreShowModel *)model index:(NSIndexPath *)indexPath;
@end
