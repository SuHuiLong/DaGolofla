//
//  JGLPowerSettTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPowerSettTableViewCell.h"
#import "UITool.h"
@implementation JGLPowerSettTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
   
    [_btnChange setTitleColor:[UITool colorWithHexString:@"#7fc1ff" alpha:1] forState:UIControlStateNormal];
    [_btnChange.layer setBorderWidth:1.0]; //边框宽度
    _btnChange.layer.borderColor = [[UITool colorWithHexString:@"#7fc1ff" alpha:1] CGColor];
    _btnChange.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    _btnChange.layer.masksToBounds = YES;
    _btnChange.layer.cornerRadius = 8*screenWidth/320;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
