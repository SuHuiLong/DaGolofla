//
//  JGLGroupClubTitleTableViewCell.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGroupClubTitleTableViewCell.h"

@implementation JGLGroupClubTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth - 20*ProportionAdapter, 70*ProportionAdapter)];
        _backImgv.image = [UIImage imageNamed:@"1"];
        [self.contentView addSubview:_backImgv];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
