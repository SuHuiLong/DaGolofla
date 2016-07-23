//
//  JGLActiveChooseSTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActiveChooseSTableViewCell.h"

@implementation JGLActiveChooseSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        [self addSubview:_labelTitle];
        
        _imgvDel = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 40*ScreenWidth/375, 10*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375)];
        _imgvDel.image = [UIImage imageNamed:@"remove"];
        [self addSubview:_imgvDel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
