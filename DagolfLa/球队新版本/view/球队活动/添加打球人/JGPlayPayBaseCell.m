//
//  JGPlayPayBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGPlayPayBaseCell.h"

@implementation JGPlayPayBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nameLeft.constant = 40 *ProportionAdapter;
    
    self.price.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.priceUnit.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.couponsImageViewLeft.constant = 20 *ProportionAdapter;
    
    self.deletePalyBtnRight.constant = 10 *ProportionAdapter;
    
    self.couponsLabel = [[UILabel alloc]initWithFrame:CGRectMake( self.couponsImageView.frame.size.width / 4, self.couponsImageView.frame.size.height / 10, self.couponsImageView.frame.size.width/4*2, self.couponsImageView.frame.size.height/2)];
    self.couponsLabel.textAlignment = NSTextAlignmentCenter;
    self.couponsLabel.textColor = [UIColor whiteColor];
    [self.couponsLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)deletePalyBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate deletePalyBaseBtn:sender];
    }
}

- (void)configJGPlayPayBaseCell:(NSMutableDictionary *)dict{
    if ([dict objectForKey:@"name"]) {
        self.name.text = [dict objectForKey:@"name"];
    }else{
        self.name.text = @"";
    }
    
    if ([dict objectForKey:@"money"]) {
        self.price.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"money"]];
    }else{
        self.price.text = @"";
    }
    
    //优惠券价格
    if ([dict objectForKey:@"subsidyPrice"]) {
        self.couponsImageView.hidden = NO;
        
        self.couponsLabel.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"subsidyPrice"] floatValue]];
        [self.couponsImageView addSubview:self.couponsLabel];
    }else{
        self.couponsImageView.hidden = YES;
    }
}

@end
