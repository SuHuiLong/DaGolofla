//
//  JGHSimpleScorePepoleBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSimpleScorePepoleBaseCell.h"
#import "JGLAddActiivePlayModel.h"

@implementation JGHSimpleScorePepoleBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.userImageView.image = [UIImage imageNamed:DefaultHeaderImage];
    
    self.userImageViewWith.constant = 40 *ProportionAdapter;
    self.userImageViewLeft.constant = 10 *ProportionAdapter;
    
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    
    self.userName.font = [UIFont systemFontOfSize:15.0 *ProportionAdapter];
    self.userNameLeft.constant = 10 *ProportionAdapter;
    
    self.almost.font = [UIFont systemFontOfSize:15.0 *ProportionAdapter];
    self.almostLeft.constant = 10 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configScoreJGLAddActiivePlayModel:(JGLAddActiivePlayModel *)model{
    self.userImageView.image = nil;
    
    [self.userImageView sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    if (model.userName) {
        self.userName.text = model.name;
    }else{
        self.userName.text = @"";
    }
    
    self.almost.text = [NSString stringWithFormat:@"差点：%.f", [model.almost floatValue]];
}

@end
