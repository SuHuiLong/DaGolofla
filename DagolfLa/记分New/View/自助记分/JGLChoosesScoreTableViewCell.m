//
//  JGLChoosesScoreTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLChoosesScoreTableViewCell.h"
#import "UITool.h"
@implementation JGLChoosesScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 12*screenWidth/375, 69*screenWidth/375, 69*screenWidth/375)];
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.layer.cornerRadius = 8* screenWidth / 375;
        [self.contentView addSubview:_iconImgv];
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(90*screenWidth/375, 10*screenWidth/375, 180*screenWidth/375, 36*screenWidth/375)];
        _labelName.text = @"上海宝马杯高尔夫球赛";
        _labelName.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self.contentView addSubview:_labelName];
        
        _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(220*screenWidth/375, 10*screenWidth/375, 130*screenWidth/375, 36*screenWidth/375)];
        _labelTime.font = [UIFont systemFontOfSize:10*screenWidth/375];
        [self.contentView addSubview:_labelTime];
        _labelTime.textAlignment = NSTextAlignmentRight;
        _labelTime.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
        _labelTime.text = @"07月20日";
        
        
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(90*screenWidth/375, 46*screenWidth/375, screenWidth-100*screenWidth/375, 1)];
        _viewLine.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
        [self.contentView addSubview:_viewLine];
        
        
        _distanceImgv = [[UIImageView alloc]initWithFrame:CGRectMake(90*screenWidth/375, 56*screenWidth/375, 11*screenWidth/375, 15*screenWidth/375)];
        _distanceImgv.image = [UIImage imageNamed:@"juli"];
        [self.contentView addSubview:_distanceImgv];
        
        _labelBall = [[UILabel alloc]initWithFrame:CGRectMake(110*screenWidth/375, 47*screenWidth/375, 250*screenWidth/375, 35*screenWidth/375)];
        _labelBall.font = [UIFont systemFontOfSize:12*screenWidth/375];
        _labelBall.textColor = [UITool colorWithHexString:@"666666" alpha:1];
        [self.contentView addSubview:_labelBall];
        _labelBall.text = @"上海佘山高尔夫球场";
        
        
        
    }
    return self;
}


-(void)showData:(JGLChooseScoreModel *)model
{
    [_iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[model.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    if (![Helper isBlankString:model.name]) {
        _labelName.text = model.name;
    }
    else{
        _labelName.text = [NSString stringWithFormat:@"暂无活动名"];
    }
    
    if (![Helper isBlankString:model.beginDate]) {
        NSLog(@"%@",model.beginDate);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *destDate= [dateFormatter dateFromString:model.beginDate];
        NSString* str = [NSString stringWithFormat:@"%@",destDate];
        
        NSArray* array = [str componentsSeparatedByString:@" "];
        NSArray* array1 = [array[0] componentsSeparatedByString:@"-"];
        NSArray* array2 = [array[1] componentsSeparatedByString:@":"];
        
        NSString* strTime = [NSString stringWithFormat:@"%@月%@日 %@:%@",array1[1],array1[2],array2[0],array2[1]];
        _labelTime.text = strTime;
        
    }
    else{
        _labelTime.text = @"暂无时间";
    }
    
    _labelBall.text = model.ballName;
    
}

-(void)showLiveData:(JGTeamAcitivtyModel *)model
{
    [_iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[model.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    if (![Helper isBlankString:model.name]) {
        _labelName.text = model.name;
    }
    else{
        _labelName.text = [NSString stringWithFormat:@"暂无活动名"];
    }
    
    NSArray* arr = [model.beginDate componentsSeparatedByString:@" "];
    _labelTime.text = arr[0];
    
    _labelBall.text = model.ballName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
