//
//  JGDAwardSetTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 2017/4/25.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDAwardSetTableViewCell.h"


@implementation JGDAwardSetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(101))];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        UIImageView *iconImage = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(15), kWvertical(22), kHvertical(22)) Image:[UIImage imageNamed:@"add_prize"]];
        [backView addSubview:iconImage];
        
        self.awardNameLB = [Helper lableRect:CGRectMake(kWvertical(42), kHvertical(16), kWvertical(300), kHvertical(18)) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:kHorizontal(17) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [backView addSubview:self.awardNameLB];
        
        self.trashButton = [[UIButton alloc] initWithFrame:CGRectMake(kWvertical(346), kHvertical(15), kWvertical(20), kHvertical(22))];
        [self.trashButton setImage:[UIImage imageNamed:@"trashAward"] forState:(UIControlStateNormal)];
        [backView addSubview:self.trashButton];
        
        UILabel *lineLB = [Helper lableRect:CGRectMake(0, kHvertical(50), screenWidth, 1) labelColor:[UIColor whiteColor] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [backView addSubview:lineLB];
        
        UILabel *prizeLB = [Helper lableRect:CGRectMake(kWvertical(42), kHvertical(66), kWvertical(55), kHvertical(16)) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:kHorizontal(15) text:@"奖品：" textAlignment:(NSTextAlignmentLeft)];
        [backView addSubview:prizeLB];
        
        
        self.prizeTF = [[UITextField alloc] initWithFrame:CGRectMake(kWvertical(87), kHvertical(67), kWvertical(120), kHvertical(16))];
        self.prizeTF.font = [UIFont systemFontOfSize:kHorizontal(15)];
        self.prizeTF.placeholder = @"奖品名称";
        [backView addSubview:self.prizeTF];
        
        
        UILabel *prizeCountLB = [Helper lableRect:CGRectMake(kWvertical(244), kHvertical(66), kWvertical(55), kHvertical(16)) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:kHorizontal(15) text:@"数量：" textAlignment:(NSTextAlignmentLeft)];
        [backView addSubview:prizeCountLB];
        
        
        self.prizeCountTF = [[UITextField alloc] initWithFrame:CGRectMake(kWvertical(289), kHvertical(67), kWvertical(70), kHvertical(16))];
        self.prizeCountTF.font = [UIFont systemFontOfSize:kHorizontal(15)];
        self.prizeCountTF.placeholder = @"奖品数量";
        self.prizeCountTF.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        [backView addSubview:self.prizeCountTF];
    }
    return self;
}

- (void)setModel:(JGHAwardModel *)model{
    self.awardNameLB.text = model.name;
    self.prizeTF.text = model.prizeName;
    if (model.prizeSize && [model.prizeSize integerValue] == 0) {
        self.prizeCountTF.text = @"";
    }else{
        self.prizeCountTF.text = [NSString stringWithFormat:@"%@", model.prizeSize];
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
