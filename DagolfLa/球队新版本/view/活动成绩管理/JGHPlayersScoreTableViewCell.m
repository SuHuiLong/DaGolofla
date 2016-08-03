//
//  JGHPlayersScoreTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPlayersScoreTableViewCell.h"

@implementation JGHPlayersScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageScoreLeft.constant = 30*ProportionAdapter;
    self.imageScoreRight.constant = 30*ProportionAdapter;
   
    self.imageScoreWith.constant = 18*ProportionAdapter;
    
    self.fristLabel.font= [UIFont systemFontOfSize:15 *ProportionAdapter];

    self.twoLabel.font= [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.threeLabel.font= [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.fiveLabel.font= [UIFont systemFontOfSize:15 *ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
