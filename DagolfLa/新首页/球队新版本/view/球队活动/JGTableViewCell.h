//
//  JGTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;
//@class JGHPublishEventModel;

@interface JGTableViewCell : UITableViewCell
//titles
@property (weak, nonatomic) IBOutlet UILabel *titles;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contions;
//下划线
@property (weak, nonatomic) IBOutlet UILabel *underline;

- (void)configTitlesString:(NSString *)titles;

- (void)configContionsStringWhitModel:(JGTeamAcitivtyModel *)model andIndexPath:(NSIndexPath *)indexPath;

- (void)configJGTeamAcitivtyModel:(JGTeamAcitivtyModel *)model andIndecPath:(NSIndexPath *)indexPath;

- (void)configTimeString:(JGTeamAcitivtyModel *)model andTag:(NSInteger)tag;

- (void)configActivityCost:(NSMutableArray *)costArray;

- (void)configActivityInfo:(NSString *)info;

//- (void)configJGHPublishEventModel:(JGHPublishEventModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
