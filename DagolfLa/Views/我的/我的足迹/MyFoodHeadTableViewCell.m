//
//  MyFoodHeadTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/10/30.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "MyFoodHeadTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@implementation MyFoodHeadTableViewCell

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
    _imgvYuan = [[UIImageView alloc]initWithFrame:CGRectMake(3*ScreenWidth/320, 5*ScreenWidth/320, 12*ScreenWidth/320, 12*ScreenWidth/320)];
    _imgvYuan.image = [UIImage imageNamed:@"gou_w"];
    [self.contentView addSubview:_imgvYuan];
    
    _viewShu = [[UIView alloc]initWithFrame:CGRectMake(7*ScreenWidth/320, 17*ScreenWidth/320, 2*ScreenWidth/320, 68*ScreenWidth/320)];
    _viewShu.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_viewShu];
    
    _viewHen = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/320, 41*ScreenWidth/320, 40*ScreenWidth/320, 1*ScreenWidth/320)];
    _viewHen.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_viewHen];
    
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(46*ScreenWidth/320, 12*ScreenWidth/320, 60*ScreenWidth/320, 60*ScreenWidth/320)];
    _iconImage.image = [UIImage imageNamed:@"xuans"];
    [self.contentView addSubview:_iconImage];
    _iconImage.layer.cornerRadius = _iconImage.frame.size.height/2;
    _iconImage.layer.masksToBounds = YES;
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(116*ScreenWidth/320, 20*ScreenWidth/320, ScreenWidth-126*ScreenWidth/320, 22*ScreenWidth/320)];
    _labelTime.textColor = [UIColor orangeColor];
    [self.contentView addSubview:_labelTime];
    _labelTime.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(116*ScreenWidth/320, 45*ScreenWidth/320, ScreenWidth-126*ScreenWidth/320, 22*ScreenWidth/320)];
    _labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [self.contentView addSubview:_labelTitle];
    
    
    
}

- (void)showData:(MyfootModel*)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.ballPic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    _labelTime.text = [NSString stringWithFormat:@"%@",model.createTime];
    _labelTitle.text = model.golfName;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
