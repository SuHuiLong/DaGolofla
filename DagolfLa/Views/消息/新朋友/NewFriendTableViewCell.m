//
//  NewFriendTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/3/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "NewFriendTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@implementation NewFriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.userInteractionEnabled = YES;
        
        [self createView];
    }
    return self;
}

-(void)createView
{
    _btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnIcon.frame = CGRectMake(10*ScreenWidth/375, 14*ScreenWidth/375, 55*ScreenWidth/375, 55*ScreenWidth/375);
    [_btnIcon setImage:[UIImage imageNamed:@"moren.jpg"] forState:UIControlStateNormal];
    _btnIcon.layer.cornerRadius = 8*ScreenWidth/375;
    _btnIcon.layer.masksToBounds = YES;
    [self addSubview:_btnIcon];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 7*ScreenWidth/375, 150*ScreenWidth/375, 20*ScreenWidth/375)];
    _nameLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _nameLabel.text = @"溪中小鱼";
    [self addSubview:_nameLabel];
    
    _imgvSex = [[UIImageView alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 33*ScreenWidth/375, 8*ScreenWidth/375, 12*ScreenWidth/375)];
    _imgvSex.image = [UIImage imageNamed:@"xb_n"];
    [self addSubview:_imgvSex];
    
    _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*ScreenWidth/375, 28*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375)];
    _ageLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _ageLabel.text = @"18";
    [self addSubview:_ageLabel];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 50*ScreenWidth/375, 200*ScreenWidth/375, 20*ScreenWidth/375)];
    _detailLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _detailLabel.text = @"我需要三件东西。。啥玩意儿";
    [self addSubview:_detailLabel];
    
    _btnFocus = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnFocus setTitle:@"+关注" forState:UIControlStateNormal];
    _btnFocus.frame = CGRectMake(ScreenWidth-65*ScreenWidth/375, 25*ScreenWidth/375, 55*ScreenWidth/375, 30*ScreenWidth/375);
    _btnFocus.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_btnFocus.layer setMasksToBounds:YES];
    [_btnFocus.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_btnFocus.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [_btnFocus.layer setBorderColor:colorref];//边框颜色
    [_btnFocus setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];//title color
    [self addSubview:_btnFocus];

}


-(void)showData:(NewFriendModel *)model
{
    [_btnIcon sd_setImageWithURL:[Helper imageIconUrl:model.pic] forState:UIControlStateNormal];
    if (![Helper isBlankString:model.userName]) {
        _nameLabel.text = model.userName;
    }
    else
    {
        _nameLabel.text = @"暂无用户名";
    }
    if ([model.sex integerValue] == 0) {
        _imgvSex.image = [UIImage imageNamed:@"xb_n"];
    }
    else
    {
        _imgvSex.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    _ageLabel.text = [NSString stringWithFormat:@"%@",model.age];
    
    if (![Helper isBlankString:model.userSign]) {
        _detailLabel.text = model.userSign;
    }
    else
    {
        _detailLabel.text = @"用户暂无签名";
    }
    if ([model.isFollow  integerValue] == 1) {
        [_btnFocus setTitle:@"已关注" forState:UIControlStateNormal];
        [_btnFocus setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 166/255,166/255,166/255, 1 });
        [_btnFocus.layer setBorderColor:colorref];//边框颜色
    }
    else
    {
        [_btnFocus setTitle:@"+关注" forState:UIControlStateNormal];
        _btnFocus.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_btnFocus.layer setMasksToBounds:YES];
        [_btnFocus.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [_btnFocus.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
        [_btnFocus.layer setBorderColor:colorref];//边框颜色
        [_btnFocus setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];//title color
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
