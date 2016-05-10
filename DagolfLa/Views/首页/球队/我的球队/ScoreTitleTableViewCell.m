//
//  ScoreTitleTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreTitleTableViewCell.h"
#import "ViewController.h"
@implementation ScoreTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _arrTitle = [[NSArray alloc]init];
        _arrTitle = @[@"排名",@"姓名",@"上杆",@"推杆",@"总杆"];
        for (int i = 0; i < 5; i++) {
            UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/5*i, 0, ScreenWidth/5, 40*ScreenWidth/375)];
            labelTitle.text = _arrTitle[i];
            labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
            labelTitle.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:labelTitle];
            
            
            if (i > 0) {
                _viewLineHor = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/5*i, 0, 2*ScreenWidth/375, 40*ScreenWidth/375)];
                _viewLineHor.backgroundColor = [UIColor lightGrayColor];
                [self.contentView addSubview:_viewLineHor];
                
            }
        }
        _viewLineVer = [[UIView alloc]initWithFrame:CGRectMake(0, 39*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
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
