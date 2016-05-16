//
//  JGTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHLaunchActivityModel;

@interface JGTableViewCell : UITableViewCell
//titles
@property (weak, nonatomic) IBOutlet UILabel *titles;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contions;


- (void)configTitlesString:(NSString *)titles;

- (void)configContionsStringWhitModel:(JGHLaunchActivityModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
