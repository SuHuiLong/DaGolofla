//
//  JGTeamGroupCollectionViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamGroupCollectionViewCell.h"
#import "JGHPlayersModel.h"

@implementation JGTeamGroupCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configJGHPlayersModel:(JGHPlayersModel *)model{
    //image
//    @property (weak, nonatomic) IBOutlet UIImageView *headImageView;
    //名字
//    @property (weak, nonatomic) IBOutlet UILabel *name;
    self.name.text = model.name;
    //性别 差点
//    @property (weak, nonatomic) IBOutlet UILabel *sexAndValue;
    self.sexAndValue.text = [NSString stringWithFormat:@"%@ 差点:%ld", model.sex==0? @"女":@"男", (long)model.almost];
}

@end
