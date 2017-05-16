//
//  JGLChangePlayerTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLChangePlayerTableViewCell.h"

@implementation JGLChangePlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(63*screenWidth/375, 10*screenWidth/375, 30*screenWidth/375, 30*screenWidth/375)];
        _imgvIcon.image = [UIImage imageNamed:@"addP"];
        [self.contentView addSubview:_imgvIcon];
        
        
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(100*screenWidth/375, 10*screenWidth/375, 150*screenWidth/375, 30*screenWidth/375)];
        _labelTitle.text = @"点击添加更换打球人";
        _labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self.contentView addSubview:_labelTitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
