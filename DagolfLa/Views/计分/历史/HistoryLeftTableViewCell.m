//
//  HistoryLeftTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/12/2.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "HistoryLeftTableViewCell.h"
#import "UITool.h"
@implementation HistoryLeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        ////NSLog(@"%f",self.frame.size.height);
        _viewShu = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-1*ScreenWidth/375, 0, 2*ScreenWidth/375, 80*ScreenWidth/375)];
        _viewShu.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_viewShu];
        
        
        _viewHen = [[UIView alloc]initWithFrame:CGRectMake(141*ScreenWidth/375, 80*ScreenWidth/375/2-0.5*ScreenWidth/375, ScreenWidth/2-141*ScreenWidth/375, 1*ScreenWidth/375)];
        _viewHen.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_viewHen];
        
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 8*ScreenWidth/375, 133*ScreenWidth/375, 63*ScreenWidth/375)];
        _baseView.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
        [self.contentView addSubview:_baseView];
        //将图层的边框设置为圆jiao
        _baseView.layer.cornerRadius = 6*ScreenWidth/375;
        _baseView.layer.masksToBounds = YES;
        //给图层添加一个有色边框
        _baseView.layer.borderWidth = 1*ScreenWidth/375;
        _baseView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 133*ScreenWidth/375, 21*ScreenWidth/375)];
        _timeLabel.text = @"2101年12月12日";
        _timeLabel.textColor = [UIColor orangeColor];
        _timeLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_baseView addSubview:_timeLabel];
        
        _areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 21*ScreenWidth/375, 133*ScreenWidth/375, 21*ScreenWidth/375)];
        _areaLabel.text = @"上海》？》》》高尔夫球场";
        _areaLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _areaLabel.textColor = [UIColor whiteColor];
        [_baseView addSubview:_areaLabel];
        _areaLabel.textAlignment = NSTextAlignmentCenter;
        
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 42*ScreenWidth/375, 133*ScreenWidth/375, 21*ScreenWidth/375)];
        _stateLabel.text = @"待认领";
        _stateLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_baseView addSubview:_stateLabel];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
    }
    return self;
}
-(void)showData:(ScoreCardModel *)model
{
    NSArray *arrMobile = [model.scoreCreateTime componentsSeparatedByString:@" "];
    _timeLabel.text = arrMobile[0];
    
    _areaLabel.text = model.scoreObjectTitle;
    
    
//    scoreIsClaim 是否认领  0 未认领  1 认领
//    scoreisend;//是否完成 0未完成  1已完成
//    scoreIsSimple; //是否是简单计分   1 简单计分  2 专业计分 
    if ([model.scoreIsSimple integerValue] == 1) {
        if ([model.scoreWhoScoreUserId integerValue] == [[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]integerValue]) {
            _stateLabel.text = @"已完成";
            _stateLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            if ([model.scoreIsClaim integerValue] == 1) {
                _stateLabel.text = @"已完成";
                _stateLabel.textColor = [UIColor whiteColor];
            }
            else{
                _stateLabel.text = @"待认领";
                _stateLabel.textColor = [UIColor orangeColor];
            }
        }
    }
    else
    {
        if ([model.scoreWhoScoreUserId integerValue] == [[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]integerValue]) {
            if ([model.scoreisend integerValue] == 0) {
                _stateLabel.text = @"未完成";
                _stateLabel.textColor = [UIColor redColor];
            }
            else{
                _stateLabel.text = @"已完成";
                _stateLabel.textColor = [UIColor whiteColor];
            }
        }
        else
        {
            if ([model.scoreIsClaim integerValue] == 0) {
                if ([model.scoreisend integerValue] == 0) {
                    _stateLabel.text = @"未完成";
                    _stateLabel.textColor = [UIColor redColor];
                }
                else{
                    _stateLabel.text = @"待认领";
                    _stateLabel.textColor = [UIColor orangeColor];
                }
            }
            else
            {
                if ([model.scoreisend integerValue] == 0) {
                    _stateLabel.text = @"未完成";
                    _stateLabel.textColor = [UIColor redColor];
                }
                else{
                    _stateLabel.text = @"已完成";
                    _stateLabel.textColor = [UIColor whiteColor];
                }
            }
        }
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
