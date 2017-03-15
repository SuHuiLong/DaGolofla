//
//  JGDDoubleTextfiledTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 17/3/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDDoubleTextfiledTableViewCell.h"

@implementation JGDDoubleTextfiledTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.firstTF = [[UITextField alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 0, 120 * ProportionAdapter, 45 * ProportionAdapter)];
        self.firstTF.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.firstTF.placeholder = @"请输入真实姓名";
        self.firstTF.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.firstTF];
        
        self.secondTF = [[UITextField alloc] initWithFrame:CGRectMake(230 * ProportionAdapter, 0, 120 * ProportionAdapter, 45 * ProportionAdapter)];
        self.secondTF.placeholder = @"请输入手机号";
        self.secondTF.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.secondTF.keyboardType = UIKeyboardTypeNumberPad;
        self.secondTF.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.secondTF];

        UILabel *lineLB = [Helper lableRect:CGRectMake(195 * ProportionAdapter, 10 * ProportionAdapter, 1 * ProportionAdapter, 26 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:1 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [self.contentView addSubview:lineLB];
        
        
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
