//
//  JGHLableAndFileTextCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHLableAndFileTextCell.h"

@implementation JGHLableAndFileTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.titleLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.titleLableLeft.constant = 20 *ProportionAdapter;
    self.titleLableW.constant = 60 *ProportionAdapter;
    
    self.fielText.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.fielTextLeft.constant = 40 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCabbieName{
    self.titleLable.text = @"姓名";
    self.fielText.placeholder = @"请输入姓名(必填)";
}

- (void)configCabbieNumber{
    self.titleLable.text = @"球童编号";
    self.fielText.placeholder = @"请输入球童编号(必填)";
}

- (void)configCabbieLenghtService{
    self.titleLable.text = @"服务年限";
    self.fielText.placeholder = @"请输入服务年限";
}

- (void)configCabbieTitleString:(NSString *)string andVlaueString:(NSString *)valueString{
    self.titleLable.text = string;
    if (valueString.length == 0) {
        self.fielText.text = @"";
    }else{
        self.fielText.text = valueString;
    }
    
}

@end
