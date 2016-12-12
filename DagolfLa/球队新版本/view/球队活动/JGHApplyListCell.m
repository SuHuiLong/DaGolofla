//
//  JGHApplyListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHApplyListCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGHApplyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.couponsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 12)];
    self.couponsLabel.textAlignment = NSTextAlignmentCenter;
    self.couponsLabel.textColor = [UIColor whiteColor];
    [self.couponsLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- 勾选按钮事件
- (IBAction)chooseBtn:(UIButton *)sender {
    [self.chooseBtn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate didChooseBtn:sender];
    }
}
#pragma mark -- 删除按钮事件
- (IBAction)deleteBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectDeleteBtn:sender];
    }
}

- (void)configDict:(NSDictionary *)dict{
    //名字
    self.name.text = [dict objectForKey:@"name"];
//    @property (weak, nonatomic) IBOutlet UILabel *name;
    //价格
    self.price.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"money"] floatValue]];
//    @property (weak, nonatomic) IBOutlet UILabel *price;
    if ([[dict objectForKey:@"select"]isEqualToString:@"1"]) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
    }else{
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    }
    
    //优惠券价格
    if ([dict objectForKey:@"subsidyPrice"]) {
        self.couponsImageView.hidden = NO;
        
        self.couponsLabel.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"subsidyPrice"] floatValue]];
        [self.couponsImageView addSubview:self.couponsLabel];
        [self.couponsImageView bringSubviewToFront:self.couponsLabel];
    }else{
        self.couponsImageView.hidden = YES;
    }
}

- (void)configCancelApplyDict:(NSMutableDictionary *)dict{
    self.monay.hidden = YES;
    //名字
    self.name.textAlignment = NSTextAlignmentLeft;
    self.name.text = [dict objectForKey:@"name"];
    
    //价格
    self.price.font = [UIFont systemFontOfSize:15.0];
    if ([[dict objectForKey:@"payMoney"] floatValue] > 0) {
        self.price.text = [NSString stringWithFormat:@"%.2f元", [[dict objectForKey:@"money"] floatValue]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.price.text];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(self.price.text.length-1, 1)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
        self.price.attributedText = attributedString;
    }else{
        self.price.text = @"未付款";
        self.price.font = [UIFont systemFontOfSize:12.0];
    }
    
    //    @property (weak, nonatomic) IBOutlet UILabel *price;
    if ([[dict objectForKey:@"select"]isEqualToString:@"1"]) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
    }else{
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    }
    
    self.couponsImageView.hidden = YES;
    self.deleteBtn.hidden = YES;
}

- (void)configCancelModel:(JGTeamAcitivtyModel *)model{
    //名字
    self.name.text = model.name;
    //    @property (weak, nonatomic) IBOutlet UILabel *name;
    //价格
    self.price.text = [NSString stringWithFormat:@"%.2f", [model.money floatValue]];
    
    //优惠券价格
    if (model.userKey == [[[NSUserDefaults standardUserDefaults]objectForKey:userID] integerValue]) {
        self.couponsImageView.hidden = NO;
        
        self.couponsLabel.text = [NSString stringWithFormat:@"%.2f", [model.subsidyPrice floatValue]];
        [self.couponsImageView addSubview:self.couponsLabel];
    }else{
        self.couponsImageView.hidden = YES;
    }
}

@end
