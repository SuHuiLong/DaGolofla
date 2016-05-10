//
//  ManageOtherTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/1/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ManageOtherTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Helper.h"
@implementation ManageOtherTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 7*ScreenWidth/375, 30*ScreenWidth/375, 30*ScreenWidth/375)];
        [self.contentView addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(46*ScreenWidth/375, 11*ScreenWidth/375, 266*ScreenWidth/375, 21*ScreenWidth/375)];
        _nameLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

-(void)showData:(ManageApplyModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.pic]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@(待审核)",model.userName];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
