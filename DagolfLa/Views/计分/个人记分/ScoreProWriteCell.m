//
//  ScoreProWriteCell.m
//  DagolfLa
//
//  Created by bhxx on 15/12/7.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ScoreProWriteCell.h"

@implementation ScoreProWriteCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, 60*ScreenWidth/375)];
        _labelName.text = @"李丽";
        _labelName.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _labelName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelName];
        
        
        _textPole = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth/4, 0, ScreenWidth/4, 60*ScreenWidth/375)];
//        _textPole.delegate = self;
        _textPole.placeholder = @"请输入杆数";
        _textPole.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _textPole.textAlignment = NSTextAlignmentCenter;
        _textPole.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_textPole];
        
        
        _textPush = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/4, 60*ScreenWidth/375)];
        //        _textPole.delegate = self;
        _textPush.placeholder = @"请输入推杆数";
        _textPush.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _textPush.textAlignment = NSTextAlignmentCenter;
        _textPush.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_textPush];
        
        _btnStreet = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2+ScreenWidth/4, 0, ScreenWidth/4, 60*ScreenWidth/375)];
        //    _btnChoose.backgroundColor = [UIColor redColor];
        [_btnStreet setImage:[UIImage imageNamed:@"sqd"] forState:UIControlStateNormal];
        [self.contentView addSubview:_btnStreet];
//        _btnStreet.tag = 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
