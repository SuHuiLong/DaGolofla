//
//  JGLAddBankNewsTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddBankNewsTableViewCell.h"

@implementation JGLAddBankNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 100*screenWidth/375, 44*screenWidth/375)];
        _labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_labelTitle];
        
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(120*screenWidth/375, 0, screenWidth-130*screenWidth/375, 44*screenWidth/375)];
        _textField.returnKeyType = UIReturnKeyDefault;
        _textField.font = [UIFont systemFontOfSize:14*screenWidth/375];
        [self addSubview:_textField];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
