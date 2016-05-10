//
//  ShieldingTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/3/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ShieldingTableViewCell.h"
#import "Helper.h"
#import "UIButton+WebCache.h"
@implementation ShieldingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}


-(void)createView
{
    _btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnIcon.frame = CGRectMake(8*ScreenWidth/375, 8*ScreenWidth/375, 34*ScreenWidth/375, 34*ScreenWidth/375);
//    [_btnIcon setImage:[UIImage imageNamed:@"tx1"] forState:UIControlStateNormal];
    [self addSubview:_btnIcon];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*ScreenWidth/375, 15*ScreenWidth/375, 150*ScreenWidth/375, 20*ScreenWidth/375)];
    _nameLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _nameLabel.text = @"溪中小鱼";
    [self addSubview:_nameLabel];
    
}
-(void)showData:(ScreenModel *)model
{
//    [_btnIcon sd_setBackgroundImageWithURL:[Helper imageIconUrl:model.userPic] forState:UIControlStateNormal];
    [_btnIcon sd_setBackgroundImageWithURL:[Helper imageIconUrl:model.userPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren.jpg"]];
    
    
    if (![Helper isBlankString:model.userName]) {
        _nameLabel.text = model.userName;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
