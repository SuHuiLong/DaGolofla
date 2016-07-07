//
//  JGDActvityPriziSetTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDActvityPriziSetTableViewCell.h"

@interface JGDActvityPriziSetTableViewCell ()


@end



@implementation JGDActvityPriziSetTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 0, 200 * ProportionAdapter, 44 * ProportionAdapter)];
        self.titleLB.text = @"活动奖项（20）";
        [self.contentView addSubview:self.titleLB];
        
        self.prizeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.prizeBtn.frame = CGRectMake(220 * ProportionAdapter, 10 * ProportionAdapter, 70 * ProportionAdapter, 25 * ProportionAdapter);
        [self.prizeBtn setTitle:@"奖项设置" forState:(UIControlStateNormal)];
        [self.prizeBtn setTitleColor:[UIColor colorWithHexString:@"#f39800"] forState:(UIControlStateNormal)];
        self.prizeBtn.titleLabel.font = [UIFont systemFontOfSize:13 * ScreenWidth / 375];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0.96, 0.61, 0.03, 1.00 });
        self.prizeBtn.layer.borderColor = borderColorRef;
        self.prizeBtn.layer.borderWidth = 1.00 * ScreenWidth / 375;
        self.prizeBtn.layer.cornerRadius = 3.5 * ScreenWidth / 375;
//        [self.contentView addSubview:self.prizeBtn];
        
        self.presentationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.presentationBtn.frame = CGRectMake(300 * ProportionAdapter, 10 * ProportionAdapter, 70 * ProportionAdapter, 25 * ProportionAdapter);
        [self.presentationBtn setTitle:@"立即颁奖" forState:(UIControlStateNormal)];
        
        self.presentationBtn.titleLabel.font = [UIFont systemFontOfSize:13 * ScreenWidth / 375];
        [self.presentationBtn setTitleColor:[UIColor colorWithHexString:@"#f39800"] forState:(UIControlStateNormal)];
        self.presentationBtn.layer.borderWidth = 1.00 * ScreenWidth / 375;
        self.presentationBtn.layer.cornerRadius = 3.5 * ScreenWidth / 375;
        self.presentationBtn.layer.borderColor = borderColorRef;
        
//        [self.contentView addSubview:self.presentationBtn];
        

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
