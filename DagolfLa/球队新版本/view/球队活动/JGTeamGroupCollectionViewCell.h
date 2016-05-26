//
//  JGTeamGroupCollectionViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHPlayersModel;

@interface JGTeamGroupCollectionViewCell : UICollectionViewCell
//image
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//名字
@property (weak, nonatomic) IBOutlet UILabel *name;
//性别 差点
@property (weak, nonatomic) IBOutlet UILabel *sexAndValue;


- (void)configJGHPlayersModel:(JGHPlayersModel *)model;

@end
