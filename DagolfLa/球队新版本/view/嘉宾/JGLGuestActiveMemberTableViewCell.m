//
//  JGLGuestActiveMemberTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGuestActiveMemberTableViewCell.h"

@implementation JGLGuestActiveMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(5*screenWidth/375, 5*screenWidth/375, 40*screenWidth/375, 40*screenWidth/375)];
        [self addSubview:_iconImgv];
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.layer.cornerRadius = 40*screenWidth/375/2;
        [_iconImgv setImage:[UIImage imageNamed:DefaultHeaderImage]];//moren
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*screenWidth/375, 5*screenWidth/375, 200*screenWidth/375, 20*screenWidth/375)];
        _nameLabel.text = @"没什么特长就名字特长";
        _nameLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor blackColor];
        
        
        _sexImgv = [[UIImageView alloc]initWithFrame:CGRectMake(60*screenWidth/375, 30*screenWidth/375, 12*screenWidth/375, 16*screenWidth/375)];
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
        [self addSubview:_sexImgv];
        
        _almostLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*screenWidth/375, 30*screenWidth/375, 80*screenWidth/375, 20*screenWidth/375)];
        _almostLabel.textColor = [UIColor blackColor];
        _almostLabel.text = @"差点 39";
        [self addSubview:_almostLabel];
        _almostLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        
        _mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth -120 *ProportionAdapter, 20*screenWidth/375, 100*screenWidth/375, 20*screenWidth/375)];
        _mobileLabel.textColor = [UIColor blackColor];
        _mobileLabel.textAlignment = NSTextAlignmentRight;
        _mobileLabel.text = @"188****0055";
        [self addSubview:_mobileLabel];
        _mobileLabel.textColor = [UIColor lightGrayColor];
        _mobileLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
//        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(250*screenWidth/375, 20*screenWidth/375, 80*screenWidth/375, 20*screenWidth/375)];
//        _moneyLabel.textColor = [UIColor blackColor];
//        _moneyLabel.textAlignment = NSTextAlignmentCenter;
//        
//        _moneyLabel.hidden = NO;
//        [self addSubview:_moneyLabel];
//        _moneyLabel.layer.cornerRadius = 5*screenWidth/375;
//        _moneyLabel.layer.masksToBounds = YES;
//        _moneyLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
