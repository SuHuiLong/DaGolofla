//
//  JGHApplyNewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHApplyNewCell.h"

@implementation JGHApplyNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.couponsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 12)];
    self.couponsLabel.textAlignment = NSTextAlignmentCenter;
    self.couponsLabel.textColor = [UIColor whiteColor];
    [self.couponsLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8.0]];
    
    self.name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nameLeft.constant = 37 *ProportionAdapter;
    
    self.nameW.constant = 80 *ProportionAdapter;
    
    self.priceBtnLeft.constant = 10 *ProportionAdapter;
    
    self.editorBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.priceBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.preferpriceImageViewRight.constant = 20 *ProportionAdapter;
    self.deleBtnRight.constant = 20 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editorBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectEditorBtn:sender];
    }
}
- (IBAction)deleBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectApplyDeleteBtn:sender];
    }
}

- (void)configDict:(NSDictionary *)dict{
    //名字
    self.name.text = [dict objectForKey:@"name"];
    
    //价格
    [self.priceBtn setTitle:[NSString stringWithFormat:@"%.2f元", [[dict objectForKey:@"money"] floatValue]] forState:UIControlStateNormal];
    
    //优惠券价格
    if ([dict objectForKey:@"subsidyPrice"]) {
        self.preferpriceImageView.hidden = NO;
        NSLog(@"==== %.2f", [[dict objectForKey:@"subsidyPrice"] floatValue]);
        self.couponsLabel.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"subsidyPrice"] floatValue]];
        [self.preferpriceImageView addSubview:self.couponsLabel];
        [self.preferpriceImageView bringSubviewToFront:self.couponsLabel];
    }else{
        self.preferpriceImageView.hidden = YES;
    }
}

@end
