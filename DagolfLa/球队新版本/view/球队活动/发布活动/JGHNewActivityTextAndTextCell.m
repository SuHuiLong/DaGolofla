//
//  JGHNewActivityTextAndTextCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewActivityTextAndTextCell.h"

@implementation JGHNewActivityTextAndTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _nameText = [[UITextField alloc]initWithFrame:CGRectMake(40*ProportionAdapter, 10*ProportionAdapter, (screenWidth -73*ProportionAdapter)/2, 22*ProportionAdapter)];
        _nameText.placeholder = @"请输入姓名";
        _nameText.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _nameText.textColor = [UIColor colorWithHexString:Ba0_Color];
        _nameText.textAlignment = NSTextAlignmentLeft;
        _nameText.clearButtonMode = UITextFieldViewModeAlways;
        [self addSubview:_nameText];
        
        _hvrLine = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 -0.5, 10*ProportionAdapter, 0.5, 26*ProportionAdapter)];
        _hvrLine.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
        [self addSubview:_hvrLine];
        
        _mobileText = [[UITextField alloc]initWithFrame:CGRectMake(screenWidth/2 -5*ProportionAdapter, 10*ProportionAdapter, screenWidth/2 -38*ProportionAdapter, 22*ProportionAdapter)];
        _mobileText.placeholder = @"请输入联系方式";
        _mobileText.clearButtonMode = UITextFieldViewModeAlways;
        _mobileText.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _mobileText.textColor = [UIColor colorWithHexString:Ba0_Color];
        _mobileText.textAlignment = NSTextAlignmentRight;
        [self addSubview:_mobileText];
    }
    return self;
}

- (void)configJGHNewActivityTextAndTextCellName:(NSString *)name andMobile:(NSString *)mobile{
    if (name) {
        _nameText.text = name;
    }
    
    if (mobile) {
        _mobileText.text = mobile;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
