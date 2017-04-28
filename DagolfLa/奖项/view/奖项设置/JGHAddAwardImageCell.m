//
//  JGHAddAwardImageCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddAwardImageCell.h"

@implementation JGHAddAwardImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code icn_addawards
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configAddAwardImageName:(NSString *)imageName andTiles:(NSString *)title{
    self.headerImageView.image = [UIImage imageNamed:imageName];
    self.headerImageViewLeft.constant = 10 *ProportionAdapter;
    
    self.vlaue.text = title;
    self.vlaue.font = [UIFont systemFontOfSize:kHorizontal(15)];
    self.vlaueLeft.constant = 10 *ProportionAdapter;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
