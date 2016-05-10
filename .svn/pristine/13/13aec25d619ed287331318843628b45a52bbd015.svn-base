//
//  ScoreDetailTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreDetailTableViewCell.h"
#import "ViewController.h"
@implementation ScoreDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _arrTitle = [[NSArray alloc]init];
        for (int i = 0; i < 5; i++) {
            _labelNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/5, 30*ScreenWidth/375)];
            _labelNum.text = @"1";
            _labelNum.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            _labelNum.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_labelNum];
            
            _labelName = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/5, 0, ScreenWidth/5, 30*ScreenWidth/375)];
            _labelName.text = @"清风";
            _labelName.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            _labelName.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_labelName];
            
            _labelShang = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/5*2, 0, ScreenWidth/5, 30*ScreenWidth/375)];
            _labelShang.text = @"14";
            _labelShang.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            _labelShang.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_labelShang];
            
            _labelTui = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/5*3, 0, ScreenWidth/5, 30*ScreenWidth/375)];
            _labelTui.text = @"24";
            _labelTui.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            _labelTui.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_labelTui];
            
            _labelAll = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/5*4, 0, ScreenWidth/5, 30*ScreenWidth/375)];
            _labelAll.text = @"40";
            _labelAll.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            _labelAll.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_labelAll];
            
            if (i > 0) {
                _viewLineHor = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/5*i, 0, 2*ScreenWidth/375, 30*ScreenWidth/375)];
                _viewLineHor.backgroundColor = [UIColor lightGrayColor];
                [self.contentView addSubview:_viewLineHor];
                
            }
        }
        _viewLineVer = [[UIView alloc]initWithFrame:CGRectMake(0, 29*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
        _viewLineVer.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_viewLineVer];
        
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
