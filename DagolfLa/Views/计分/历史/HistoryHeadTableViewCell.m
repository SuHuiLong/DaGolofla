//
//  HistoryHeadTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/12/2.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "HistoryHeadTableViewCell.h"

@implementation HistoryHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
       
//        self.contentview.frame = self.bounds;
        self.contentView.frame = self.bounds;
        _imgvYuan = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2-7*ScreenWidth/375, 7*ScreenWidth/375, 14*ScreenWidth/375, 14*ScreenWidth/375)];
        [self.contentView addSubview:_imgvYuan];
        _imgvYuan.image = [UIImage imageNamed:@"headY"];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-1*ScreenWidth/375, 21*ScreenWidth/375, 2*ScreenWidth/375, 23*ScreenWidth/375)];
        [self.contentView addSubview:_line];
        _line.backgroundColor = [UIColor lightGrayColor];
        
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
        _label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_label];
        
    }
    return self;
}

-(void)width
{
    _imgvYuan.frame = CGRectMake(self.contentView.frame.size.width/2-7*ScreenWidth/375, 7*ScreenWidth/375, 14*ScreenWidth/375, 14*ScreenWidth/375);
    _line.frame = CGRectMake(ScreenWidth/2-1*ScreenWidth/375, 21*ScreenWidth/375, 2*ScreenWidth/375, 23*ScreenWidth/375);
    _label.frame = CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
