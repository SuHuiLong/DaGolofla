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
    
    self.couponsLabel = [[UILabel alloc]initWithFrame:CGRectMake( self.couponsImageView.frame.size.width / 4, self.couponsImageView.frame.size.height / 10, self.couponsImageView.frame.size.width/4*2, self.couponsImageView.frame.size.height/2)];
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
    [self.chooseBtn setImage:[UIImage imageNamed:@"kuangwx"] forState:UIControlStateNormal];
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
    self.price.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"payMoney"] floatValue]];
//    @property (weak, nonatomic) IBOutlet UILabel *price;
    if ([[dict objectForKey:@"select"]isEqualToString:@"1"]) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuangwx"] forState:UIControlStateNormal];
    }else{
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    }
    
    //优惠券价格
    if ([dict objectForKey:@"subsidyPrice"]) {
        self.couponsImageView.hidden = NO;
        
        self.couponsLabel.text = [NSString stringWithFormat:@"%.1f", [[dict objectForKey:@"subsidyPrice"] floatValue]];
        [self.couponsImageView addSubview:self.couponsLabel];
    }else{
        self.couponsImageView.hidden = YES;
    }
}

- (void)configCancelApplyDict:(NSMutableDictionary *)dict{
    self.monay.hidden = NO;
    //名字
    self.name.text = [dict objectForKey:@"name"];
    
    //价格
    if ([[dict objectForKey:@"payMoney"] floatValue] > 0) {
        self.price.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"payMoney"] floatValue]];
    }else{
        self.price.text = @"未付款";
        self.monay.hidden = YES;
    }
    
    //    @property (weak, nonatomic) IBOutlet UILabel *price;
    if ([[dict objectForKey:@"select"]isEqualToString:@"1"]) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuangwx"] forState:UIControlStateNormal];
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
    if ([model.subsidyPrice integerValue] > 0.0) {
        self.couponsImageView.hidden = NO;
        
        self.couponsLabel.text = [NSString stringWithFormat:@"%.1f", [model.subsidyPrice floatValue]];
        [self.couponsImageView addSubview:self.couponsLabel];
    }else{
        self.couponsImageView.hidden = YES;
    }
}

@end
