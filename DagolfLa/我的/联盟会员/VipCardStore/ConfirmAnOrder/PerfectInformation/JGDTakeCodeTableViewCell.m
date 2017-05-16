//
//  JGDTakeCodeTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 2017/4/11.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDTakeCodeTableViewCell.h"

@implementation JGDTakeCodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.txFD = [[UITextField alloc] initWithFrame:CGRectMake(20 * screenWidth / 375, 0, kWvertical(160), 51 * screenWidth / 375)];
        self.txFD.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
        self.txFD.keyboardType = UIKeyboardTypeNumberPad;

        UILabel *lineLB = [Helper lableRect:CGRectMake(kWvertical(250), 15 * ProportionAdapter, 1, 21 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#A0A0A0"];
        [self.contentView addSubview:lineLB];
        
        self.takeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.takeBtn.frame = CGRectMake(kWvertical(260), 0, kWvertical(110), 51 * ScreenWidth / 375);
        [self.takeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        self.takeBtn.titleLabel.font = [UIFont systemFontOfSize:17 * ScreenWidth / 375];
        [self.takeBtn setTitleColor:[UIColor colorWithHexString:@"#008649"] forState:(UIControlStateNormal)];

        [self.contentView addSubview:self.takeBtn];
        [self.contentView addSubview:self.txFD];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
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
