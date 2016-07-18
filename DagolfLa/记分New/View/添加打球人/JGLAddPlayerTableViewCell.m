//
//  JGLAddPlayerTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddPlayerTableViewCell.h"
#import "UITool.h"
@implementation JGLAddPlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 20*screenWidth/375, 115*screenWidth/375, 40*screenWidth/375)];
        _labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_labelTitle];
        
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(130*screenWidth/375, 20*screenWidth/375, 172*screenWidth/375, 40*screenWidth/375)];
        _textField.placeholder = @"请输入姓名";
        _textField.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _textField.layer.cornerRadius = 4*screenWidth/375;
        _textField.layer.masksToBounds = YES;
        [self addSubview:_textField];
        _textField.backgroundColor = [UIColor whiteColor];
        
        
        
        _btnAdd = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnAdd.frame = CGRectMake(298*screenWidth/375, 20*screenWidth/375, 60*screenWidth/375, 40*screenWidth/375);
        [_btnAdd setTitleColor:[UITool colorWithHexString:@"32b14d" alpha:1] forState:UIControlStateNormal];
        _btnAdd.layer.cornerRadius = 4*screenWidth/375;
        _btnAdd.layer.masksToBounds = YES;
        _btnAdd.backgroundColor = [UIColor whiteColor];
        _btnAdd.titleLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [_btnAdd setTitle:@"添加" forState:UIControlStateNormal];
        [self addSubview:_btnAdd];
        
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(300*screenWidth/375, 20*screenWidth/375, 1, 40*screenWidth/375)];
        _viewLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_viewLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
