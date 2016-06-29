//
//  JGDSetPayPasswordTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDSetPayPasswordTableViewCell.h"

@interface JGDSetPayPasswordTableViewCell ()



@end

@implementation JGDSetPayPasswordTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.LB = [[UILabel alloc] initWithFrame:CGRectMake(10 * screenWidth / 375, 0, 80 * screenWidth / 375, 44 * screenWidth / 375)];
        self.LB.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
        
        self.txFD = [[UITextField alloc] initWithFrame:CGRectMake(90 * screenWidth / 375, 0, screenWidth - 160 * screenWidth / 375, 44 * screenWidth / 375)];
        self.txFD.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
        self.takeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        self.takeBtn.frame = CGRectMake(270 * ScreenWidth / 375, 9 * ScreenWidth / 375, 95 * ScreenWidth / 375, 25 * ScreenWidth / 375);
        [self.takeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        self.takeBtn.titleLabel.font = [UIFont systemFontOfSize:13 * ScreenWidth / 375];
        [self.takeBtn setTitleColor:[UIColor colorWithRed:0.48 green:0.76 blue:1.00 alpha:1.00] forState:(UIControlStateNormal)];
        self.takeBtn.layer.borderWidth = 1.00 * ScreenWidth / 375;
        self.takeBtn.layer.cornerRadius = 3.5 * ScreenWidth / 375;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0.48, 0.76, 1.00, 1.00 });
        self.takeBtn.layer.borderColor = borderColorRef;
//        [self.takeBtn addTarget:self action:@selector(addBank) forControlEvents:(UIControlEventTouchUpInside)];

        [self.contentView addSubview:self.LB];
        [self.contentView addSubview:self.txFD];
        
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
