//
//  JGDInfoTextFieldTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 2017/4/11.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDInfoTextFieldTableViewCell.h"

@implementation JGDInfoTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.infoTextField = [[UITextField alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 0, screenWidth - 100 * ProportionAdapter, 51 * ProportionAdapter)];
        self.infoTextField.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
        self.infoTextField.textColor = [UIColor colorWithHexString:@"#313131"];
        [self.contentView addSubview:self.infoTextField];
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
