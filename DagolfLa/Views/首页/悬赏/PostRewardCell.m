//
//  PostRewardCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/2.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "PostRewardCell.h"

#import "Helper.h"
#import "NoteHandlle.h"
#import "NoteModel.h"

#import "UIImageView+WebCache.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@implementation PostRewardCell

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
    _imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/320, 10*ScreenWidth/320, 54*ScreenWidth/320, 54*ScreenWidth/320)];
    _imgvIcon.image = [UIImage imageNamed:@"moren.jpg"];
    [self.contentView addSubview:_imgvIcon];
    _imgvIcon.layer.masksToBounds = YES;
    _imgvIcon.layer.cornerRadius = 8*ScreenWidth/375;
    
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(69*ScreenWidth/320, 5*ScreenWidth/320, 170*ScreenWidth/320, 20*ScreenWidth/320)];
    _labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    _labelTitle.text = @"你大爷企鹅企鹅全文";
    [self.contentView addSubview:_labelTitle];
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-90*ScreenWidth/320, 5*ScreenWidth/320, 80*ScreenWidth/320, 20*ScreenWidth/320)];
    _labelTime.font = [UIFont systemFontOfSize:12*ScreenWidth/320];
    _labelTime.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_labelTime];
    
//    69 31 150 21
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(69*ScreenWidth/320, 31*ScreenWidth/320, 120*ScreenWidth/320, 20*ScreenWidth/320)];
    _labelName.text = @"发布人:闻醉山清风";
    _labelName.font = [UIFont systemFontOfSize:13*ScreenWidth/320];
    [self.contentView addSubview:_labelName];
    
    
    _labelJine = [[UILabel alloc]initWithFrame:CGRectMake(200*ScreenWidth/320, 31*ScreenWidth/320, 60*ScreenWidth/320, 20*ScreenWidth/320)];
    _labelJine.font = [UIFont systemFontOfSize:13*ScreenWidth/320];
    _labelJine.text = @"悬赏金额:";
    [self.contentView addSubview:_labelJine];
    
    _labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(260*ScreenWidth/320, 31*ScreenWidth/320, 60*ScreenWidth/320, 20*ScreenWidth/320)];
    _labelPrice.font = [UIFont systemFontOfSize:13*ScreenWidth/320];
    _labelPrice.textColor = [UIColor redColor];
    _labelPrice.text = @"￥1222";
    [self.contentView addSubview:_labelPrice];
    
    _labelArea = [[UILabel alloc]initWithFrame:CGRectMake(69*ScreenWidth/320, 52*ScreenWidth/320, 100*ScreenWidth/320, 20*ScreenWidth/320)];
    _labelArea.font = [UIFont systemFontOfSize:10*ScreenWidth/320];
    _labelArea.text = @"地址：12123123131";
    _labelArea.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_labelArea];
    
    
    _rewardNumber = [[UILabel alloc]initWithFrame:CGRectMake(170*ScreenWidth/320, 52*ScreenWidth/320, 70*ScreenWidth/320, 20*ScreenWidth/320)];
    _rewardNumber.font = [UIFont systemFontOfSize:10*ScreenWidth/320];
    _rewardNumber.text = @"悬赏人数";
    _rewardNumber.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_rewardNumber];
    
    UIImageView* imgvJuli = [[UIImageView alloc]initWithFrame:CGRectMake(215*ScreenWidth/320, 52*ScreenWidth/320, 9*ScreenWidth/320, 15*ScreenWidth/320)];
    imgvJuli.image = [UIImage imageNamed:@"juli"];
    [self.contentView addSubview:imgvJuli];

    _labelDistance = [[UILabel alloc]initWithFrame:CGRectMake(230*ScreenWidth/320, 52*ScreenWidth/320, 80*ScreenWidth/320, 20*ScreenWidth/320)];
    _labelDistance.text = @"1111公里";
    _labelDistance.textColor = [UIColor lightGrayColor];
    _labelDistance.font = [UIFont systemFontOfSize:10*ScreenWidth/320];
    [self.contentView addSubview:_labelDistance];
    
    
}
-(void)showData:(RewordModel *)model
{
    [_imgvIcon sd_setImageWithURL:[Helper imageIconUrl:model.uPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    if (![Helper isBlankString:model.reTitle]) {
        _labelTitle.text = model.reTitle;
    }
    else
    {
        _labelTitle.text =  @"没有悬赏标题";
    }
    
    
    
    NoteModel *noteMol = [NoteHandlle selectNoteWithUID:model.userId];
    if ([noteMol.userremarks isEqualToString:@"(null)"] || [noteMol.userremarks isEqualToString:@""] || noteMol.userremarks == nil) {
        _labelName.text = [NSString stringWithFormat:@"发布人:%@",model.userName];
    }else{
        _labelName.text = [NSString stringWithFormat:@"发布人:%@",noteMol.userremarks];
    }
    
   
//    if (![Helper isBlankString:model.userName]) {
//        _labelName.text = [NSString stringWithFormat:@"发布人:%@",model.userName];
//    }
//    else
//    {
//        _labelName.text = [NSString stringWithFormat:@"发布人:%@",model.userName];
//    }
    if (![Helper isBlankString:model.playTimes]) {
        _labelTime.text = model.playTimes;
    }
    else
    {
        _labelTime.text = @"暂无时间";
    }
    if (model.reMoney != nil) {
        if ([model.reMoney integerValue] == -1) {
            _labelPrice.text = [NSString stringWithFormat:@"￥不限"];
        }
        else
        {
            _labelPrice.text = [NSString stringWithFormat:@"￥%@",model.reMoney];
        }
        
    }
    else
    {
        _labelPrice.text = [NSString stringWithFormat:@"￥不限"];
    }
    
    if (![Helper isBlankString:model.address]) {
        _labelArea.text = [NSString stringWithFormat:@"地区:%@",model.address];
    }
    else
    {
        _labelArea.text = [NSString stringWithFormat:@"地区:不限地区"];
    }
    
//    _watchNumber.text = [NSString stringWithFormat:@"浏览人数:%@",model.seeCount];
    _rewardNumber.text = [NSString stringWithFormat:@"应赏:%@",model.joinCount];
    _labelDistance.text = [NSString stringWithFormat:@"距离:%.2f公里",[model.distance floatValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
