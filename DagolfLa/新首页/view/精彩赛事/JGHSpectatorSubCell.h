//
//  JGHSpectatorSubCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHSpectatorSubCell : UITableViewCell

@property (nonatomic, retain)UIImageView *headerImageView;

@property (nonatomic, retain)UIImageView *videoImageView;

@property (nonatomic, retain)UILabel *point;

@property (nonatomic, retain)UILabel *titleLable;

@property (nonatomic, retain)UILabel *detailLable;

- (void)configJGHSpectatorSubCell:(NSDictionary *)dict andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;

@end
