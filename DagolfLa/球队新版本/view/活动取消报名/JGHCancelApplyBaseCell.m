//
//  JGHCancelApplyBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCancelApplyBaseCell.h"

@implementation JGHCancelApplyBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = _headerImage.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configDict:(NSMutableDictionary *)dict{
    [_headerImage sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[[dict objectForKey:@"userKey"] integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"addGroup"]];
    if ([dict objectForKey:@"name"]) {
        self.name.text = [dict objectForKey:@"name"];
    }
    
    if ([dict objectForKey:@"mobile"]) {
        self.mobile.text = [dict objectForKey:@"mobile"];
    }
}

@end
