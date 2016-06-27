//
//  JGLActivityMemberTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActivityMemberTableViewCell.h"

@implementation JGLActivityMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /**
         *  @property (strong, nonatomic)  UIImageView *iconImg;
         @property (strong, nonatomic)  UILabel *nameLabel;
         @property (strong, nonatomic)  UILabel *phoneLabel;
         @property (strong, nonatomic)  UILabel *moneyLabel;
         */
        
        
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/320, 5*ScreenWidth/320, 40*ScreenWidth/320, 40*ScreenWidth/320)];
        [self addSubview:_iconImg];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(56*ScreenWidth/320, 14*ScreenWidth/320, 65*ScreenWidth/320, 21*ScreenWidth/320)];
        _nameLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
        [self addSubview:_nameLabel];
        
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(120*ScreenWidth/320, 14*ScreenWidth/320, 80*ScreenWidth/320, 21*ScreenWidth/320)];
        _phoneLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
        [self addSubview:_phoneLabel];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(210*ScreenWidth/320, 14*ScreenWidth/320, ScreenWidth-220*ScreenWidth/320, 21*ScreenWidth/320)];
        _moneyLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
        [self addSubview:_moneyLabel];
        
        
        
        
    }
    return self;
}





-(void)showData:(JGHPlayersModel *)model
{
    [_iconImg sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    _iconImg.layer.cornerRadius = 20;
    _iconImg.clipsToBounds = YES;
    
    _nameLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    if (![Helper isBlankString:model.name]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }else
    {
        _nameLabel.text = [NSString stringWithFormat:@"未填写姓名"];
    }
    
    if (![Helper isBlankString:model.mobile]) {
        _phoneLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    }
    else
    {
        _phoneLabel.text = [NSString stringWithFormat:@"未填写手机号"];
    }
    _phoneLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    if (model.payMoney != nil) {
        NSString* strMoney = [NSString stringWithFormat:@"已付: %.2f元",[model.payMoney floatValue]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMoney];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,str.length - 4)];
        //        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:NSMakeRange(0, 4)];
        //        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(4,str.length - 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0*ScreenWidth/320] range:NSMakeRange(0, 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0*ScreenWidth/320] range:NSMakeRange(4,str.length - 4)];
        
        _moneyLabel.attributedText = str;
    }
    _moneyLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
