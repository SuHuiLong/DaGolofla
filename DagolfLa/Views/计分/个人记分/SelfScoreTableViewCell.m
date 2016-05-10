//
//  SelfScoreTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/8/19.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "SelfScoreTableViewCell.h"
#import "ViewController.h"
#import "ScoreWriteProController.h"
@implementation SelfScoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createTitle];
        
        [self createButton];
    }
    return self;
}

-(void)createTitle
{
    _labelHole = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 50*ScreenWidth/375, 50*ScreenWidth/375)];
    _labelHole.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_labelHole];
    _labelHole.font = [UIFont systemFontOfSize:15*ScreenWidth/375];

    
    
    _labelPar = [[UILabel alloc]initWithFrame:CGRectMake(71*ScreenWidth/375, 0, 50*ScreenWidth/375, 50*ScreenWidth/375)];
    _labelPar.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_labelPar];
    _labelPar.text = @"4";
    _labelHole.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
}
//记分的数值
-(void)createButton
{
//    for (int i = 0; i < 4; i++) {
    _scoreVFirst = [[ScoreView alloc]initWithFrame:CGRectMake(132*ScreenWidth/375, 0, 50*ScreenWidth/375, 50*ScreenWidth/375)];
    [self.contentView addSubview:_scoreVFirst];
    _imgvStreet1 = [[UIImageView alloc]initWithFrame:CGRectMake(181*ScreenWidth/375, 20*ScreenWidth/375, 9*ScreenWidth/375, 9*ScreenWidth/375)];
    _imgvStreet1.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_imgvStreet1];
    
    _scoreVSecond = [[ScoreView alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375, 0, 50*ScreenWidth/375, 50*ScreenWidth/375)];
    [self.contentView addSubview:_scoreVSecond];
    _imgvStreet2 = [[UIImageView alloc]initWithFrame:CGRectMake(181*ScreenWidth/375 + 61*ScreenWidth/375, 20*ScreenWidth/375, 9*ScreenWidth/375, 9*ScreenWidth/375)];
    _imgvStreet2.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_imgvStreet2];
    
    _scoreVThird = [[ScoreView alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*2, 0, 50*ScreenWidth/375, 50*ScreenWidth/375)];
    [self.contentView addSubview:_scoreVThird];
    _imgvStreet3 = [[UIImageView alloc]initWithFrame:CGRectMake(181*ScreenWidth/375 + 61*ScreenWidth/375*2, 20*ScreenWidth/375, 9*ScreenWidth/375, 9*ScreenWidth/375)];
    _imgvStreet3.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_imgvStreet3];
    
    _scoreVFourth = [[ScoreView alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*3, 0, 50*ScreenWidth/375, 50*ScreenWidth/375)];
    [self.contentView addSubview:_scoreVFourth];

    _imgvStreet4 = [[UIImageView alloc]initWithFrame:CGRectMake(181*ScreenWidth/375 + 61*ScreenWidth/375*3, 20*ScreenWidth/375, 9*ScreenWidth/375, 9*ScreenWidth/375)];
    _imgvStreet4.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_imgvStreet4];
        

    
}

-(void)showData:(ScoreProModel *)model
{
    _labelPar.text = [NSString stringWithFormat:@"%@",model.scoreStandardleverNums];
}



//标准杆数据
-(void)showStanded:(ScoreProStandedModel *)model
{
    _labelPar.text = [NSString stringWithFormat:@"%@",model.professionalStandardlever];
}

//得分数据
-(void)showScoreData:(ScoreProListModel *)model
{
    _scoreVFirst.labelUp.text = [NSString stringWithFormat:@"%@",model.professionalPolenumber];
    _scoreVFirst.labelLeft.text = [NSString stringWithFormat:@"%@",model.professionalPushrod];
    ////NSLog(@"%@",model.professionalPoor);
    _scoreVFirst.labelRight.text = [NSString stringWithFormat:@"%@",model.professionalPoor];
    if ([model.professionalOnthefairway integerValue] == 1) {
        _imgvStreet1.image = [UIImage imageNamed:@"wsqd"];
    }
    else
    {
        _imgvStreet1.image = [UIImage imageNamed:@"sqd"];
    }

}
//得分数据
-(void)showScore1Data:(ScoreProListModel *)model
{
    _scoreVSecond.labelUp.text = [NSString stringWithFormat:@"%@",model.professionalPolenumber];
    _scoreVSecond.labelLeft.text = [NSString stringWithFormat:@"%@",model.professionalPushrod];
    ////NSLog(@"%@",model.professionalPoor);
    _scoreVSecond.labelRight.text = [NSString stringWithFormat:@"%@",model.professionalPoor];
    if ([model.professionalOnthefairway integerValue] == 1) {
        _imgvStreet2.image = [UIImage imageNamed:@"wsqd"];
    }
    else
    {
        _imgvStreet2.image = [UIImage imageNamed:@"sqd"];
    }
    
}
//得分数据
-(void)showScore2Data:(ScoreProListModel *)model
{
    _scoreVThird.labelUp.text = [NSString stringWithFormat:@"%@",model.professionalPolenumber];
    _scoreVThird.labelLeft.text = [NSString stringWithFormat:@"%@",model.professionalPushrod];
    ////NSLog(@"%@",model.professionalPoor);
    _scoreVThird.labelRight.text = [NSString stringWithFormat:@"%@",model.professionalPoor];
    if ([model.professionalOnthefairway integerValue] == 1) {
        _imgvStreet3.image = [UIImage imageNamed:@"wsqd"];
    }
    else
    {
        _imgvStreet3.image = [UIImage imageNamed:@"sqd"];
    }
    
}
//得分数据
-(void)showScore3Data:(ScoreProListModel *)model
{
    _scoreVFourth.labelUp.text = [NSString stringWithFormat:@"%@",model.professionalPolenumber];
    _scoreVFourth.labelLeft.text = [NSString stringWithFormat:@"%@",model.professionalPushrod];
    ////NSLog(@"%@",model.professionalPoor);
    _scoreVFourth.labelRight.text = [NSString stringWithFormat:@"%@",model.professionalPoor];
    if ([model.professionalOnthefairway integerValue] == 1) {
        _imgvStreet4.image = [UIImage imageNamed:@"wsqd"];
    }
    else
    {
        _imgvStreet4.image = [UIImage imageNamed:@"sqd"];
    }
    
}

@end
