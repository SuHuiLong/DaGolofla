//
//  ManageMainTableCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/19.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ManageMainTableCell.h"
#import "Helper.h"
#import "ViewController.h"
#import "UIImageView+WebCache.h"
@implementation ManageMainTableCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSString* str = @"上海高尔夫球会";
//        CGFloat weight = [Helper textWidthFromTextString:str height:20*ScreenWidth/375 fontSize:15*ScreenWidth/375];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 8*ScreenWidth/375, ScreenWidth-116*ScreenWidth/375, 20*ScreenWidth/375)];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _titleLabel.text = str;
        
        _imgvSuo = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-100*ScreenWidth/375, 12*ScreenWidth/375, 10*ScreenWidth/375, 11*ScreenWidth/375)];
        _imgvSuo.image = [UIImage imageNamed:@"tuSuo"];
        [self addSubview:_imgvSuo];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 32*ScreenWidth/375, 180*ScreenWidth/375, 20*ScreenWidth/375)];
        [self addSubview:_timeLabel];
        _timeLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.text = @"2014-12-12";
        
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(190*ScreenWidth/375, 32*ScreenWidth/375, 76*ScreenWidth/375, 20*ScreenWidth/375)];
        [self addSubview:_stateLabel];
        _stateLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
        _stateLabel.textColor = [UIColor colorWithRed:0.33f green:0.71f blue:0.32f alpha:1.00f];
        _stateLabel.text = @"(正在直播)";
        
        _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 57*ScreenWidth/375, ScreenWidth-108*ScreenWidth/375, 20*ScreenWidth/375)];
        [self addSubview:_placeLabel];
        _placeLabel.text = @"上海佘山高尔夫球为企鹅全文";
        _placeLabel.textColor = [UIColor lightGrayColor];
        _placeLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        
        
        _juliImgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-100*ScreenWidth/375, 60*ScreenWidth/375, 10*ScreenWidth/375, 16*ScreenWidth/375)];
        [_juliImgv setImage:[UIImage imageNamed:@"juli"]];
        [self addSubview:_juliImgv];
        
        _areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-80*ScreenWidth/375, 57*ScreenWidth/375, 72*ScreenWidth/375, 20*ScreenWidth/375)];
        _areaLabel.textColor = [UIColor lightGrayColor];
        _areaLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
        _areaLabel.text = @"222公里";
        [self addSubview:_areaLabel];
        
        
        _jiantouImgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-21*ScreenWidth/375, self.frame.size.height/2+5*ScreenWidth/375, 13*ScreenWidth/375, 20*ScreenWidth/375)];
        [_jiantouImgv setImage:[UIImage imageNamed:@"left_jt"]];
        [self addSubview:_jiantouImgv];
        
    }
    return self;
}

-(void)showData:(GameModel *)model
{
//    titleLabel;

    _titleLabel.text = model.eventTite;
    
    if ([model.eventIsPrivate integerValue] == 1) {
        _imgvSuo.hidden = YES;
    }
    else
    {
        _imgvSuo.hidden = NO;
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@  %@",model.eventdate,model.eventTime];
    if ([model.eventisEndStart integerValue] == 1) {
        _stateLabel.text = @"正在直播";
        _stateLabel.textColor = [UIColor redColor];
        
    }
    else if ([model.eventisEndStart integerValue] == 2)
    {
        _stateLabel.text = @"未开始";
//        _stateLabel.textColor = [UIColor colorWithRed:0.33f green:0.71f blue:0.32f alpha:1.00f];
        _stateLabel.textColor = [UIColor colorWithRed:0.33f green:0.71f blue:0.32f alpha:1.00f];
    }
    else
    {
        _stateLabel.text = @"已结束";
        _stateLabel.textColor = [UIColor colorWithRed:0.93f green:0.27f blue:0.18f alpha:1.00f];
    }
    _placeLabel.text = model.eventBallName;
    _areaLabel.text = [NSString stringWithFormat:@"%@公里",model.distance];
//    _stateLabel.text = model.eventisEndStart;
//    _placeLabel.text = model.ev
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
