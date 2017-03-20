//
//  JGHNewActivityExplainCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHNewActivityExplainCell : UITableViewCell

@property (nonatomic, strong)UILabel *contentLable;

@property (nonatomic, strong)UILabel *line;

- (void)configJGHNewActivityExplainCellContent:(NSString *)content;

@end
