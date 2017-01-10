//
//  JGDBallPlayTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDBallPlayTableViewCell.h"


@interface JGDBallPlayTableViewCell ()

@end


@implementation JGDBallPlayTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(5 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter)];
        self.titleLB.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
        self.titleLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        self.titleLB.text = @"打球人：";
        self.titleLB.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.titleLB];
        
        self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 0, 245 * ProportionAdapter, 50 * ProportionAdapter)];
        self.nameTF.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
        self.nameTF.placeholder = @"必填";
        self.nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:self.nameTF];
        
        self.phoneImageV = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 32 * ProportionAdapter, 14 * ProportionAdapter, 22 * ProportionAdapter, 22 * ProportionAdapter)];
        [self.phoneImageV setImage:[UIImage imageNamed:@"order_phone"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:self.phoneImageV];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 0, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter)];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
