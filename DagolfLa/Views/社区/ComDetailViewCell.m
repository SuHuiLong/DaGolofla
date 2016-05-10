//
//  ComDetailViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/26.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ComDetailViewCell.h"

#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "ComDeatailModel.h"


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@implementation ComDetailViewCell


- (void)awakeFromNib {
    _lou = 0;
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 1, 45, 45)];
    
    [self.contentView addSubview:_iconImage];
    
    
    _labelName = [[UILabel alloc]init];
    _labelName.font = [UIFont systemFontOfSize:13];
    _labelName.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.00f];
    [self.contentView addSubview:_labelName];

//    _labelFlood = [[UILabel alloc]init];
//    _labelFlood.font = [UIFont systemFontOfSize:10];
//    _labelFlood.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.00f];
//    [self.contentView addSubview:_labelFlood];
    
    _labelDetail = [[UILabel alloc]init];
    _labelDetail.numberOfLines = 0;
    _labelDetail.font = [UIFont systemFontOfSize:15];
    _labelDetail.textColor = [UIColor colorWithRed:0.38f green:0.38f blue:0.39f alpha:1.00f];
    [self.contentView addSubview:_labelDetail];

    _labelTime = [[UILabel alloc]init];
    _labelTime.font = [UIFont systemFontOfSize:13];
    _labelTime.textColor = [UIColor colorWithRed:0.38f green:0.38f blue:0.39f alpha:1.00f];
    [self.contentView addSubview:_labelTime];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)showData:(ComDeatailModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    _iconImage.layer.cornerRadius = 8*ScreenWidth/375;
    _iconImage.layer.masksToBounds = YES;

    _labelTime.text = [model.createTime substringToIndex:16];
    CGFloat labelTimeW = [model.createTime boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]} context:nil].size.width;
//    _labelTime.backgroundColor = [UIColor yellowColor];
    _labelTime.frame = CGRectMake(ScreenWidth - labelTimeW - 10, 5, labelTimeW, 20);

    _labelName.text = model.userName;
    CGFloat labelNameW = [model.userName boundingRectWithSize:CGSizeMake(ScreenWidth - _iconImage.frame.size.width - _labelTime.frame.size.width - 20, 20) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]} context:nil].size.width;
//    _labelName.backgroundColor = [UIColor purpleColor];
    _labelName.frame = CGRectMake(_iconImage.frame.size.width+10, 5, labelNameW, 20);
    

//    _labelFlood.frame = CGRectMake(_iconImage.frame.origin.x+_iconImage.frame.size.width+5, _labelName.frame.origin.y+_labelName.frame.size.height,ScreenWidth - _labelTime.frame.size.width - _iconImage.frame.size.width - 20, 20);
   
    _labelDetail.text = model.commentContent;
    CGFloat labelDetailH = [model.commentContent boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size.height;
    _labelDetail.frame = CGRectMake(10,_iconImage.frame.origin.y+_iconImage.frame.size.height+5, ScreenWidth - 20, labelDetailH);
}
-(void)showAppData:(AppraiseModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.uPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    
    _labelTime.text = [model.createTime substringToIndex:10];
    
    _labelName.text = model.userName;
    
//    _labelFlood.text = @"#第几楼";
    
    _labelDetail.text = model.content;
}

//-(void)showNumber:(NSInteger )index{
//    _labelFlood.text = [NSString stringWithFormat:@"#第%ld楼",index];
//}



@end
