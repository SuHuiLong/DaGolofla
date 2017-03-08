//
//  JGHIndexSystemMessageCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHIndexSystemMessageCell : UITableViewCell

@property (nonatomic, retain)UIButton *systemImageBtn;

@property (nonatomic, retain)UILabel *line;

@property (nonatomic, retain)UILabel *titleLable;

@property (nonatomic, retain)UIImageView *directionImageView;

@property (nonatomic, retain)UILabel *detailLable;

- (void)configJGHIndexSystemMessageCell;

@end
