//
//  JGLAddressAddTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddressAddTableViewCell.h"

@implementation JGLAddressAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgvState = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 15*screenWidth/375, 20*screenWidth/375, 20*screenWidth/375)];
        [self addSubview:_imgvState];
        _imgvState.image = [UIImage imageNamed:@"dot_wu"];
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(40*screenWidth/375, 15*screenWidth/375, 100*screenWidth/375, 20*screenWidth/375)];
        _labelName.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _labelName.text = @"MartinLeeeee";
        [self addSubview:_labelName];
        
        _labelMobile = [[UILabel alloc]initWithFrame:CGRectMake(150*screenWidth/375, 15*screenWidth/375, 150*screenWidth/375, 20*screenWidth/375)];
        _labelMobile.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _labelMobile.text = @"18721263918";
        [self addSubview:_labelMobile];
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
