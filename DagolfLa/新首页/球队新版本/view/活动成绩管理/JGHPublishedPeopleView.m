//
//  JGHPublishedPeopleView.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPublishedPeopleView.h"

@implementation JGHPublishedPeopleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor redColor];
}

- (void)layoutSubviews{
//    self.backgroundColor = [UIColor redColor];
    self.imageLeft.constant = 13 *ProportionAdapter;
    
    self.selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.selectAllBtnWith.constant = 50 *ProportionAdapter;
    
    self.proLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.provalue.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    
    self.publishedBtn.backgroundColor = [UIColor colorWithHexString:@"#3AAF55"];
    self.publishedBtn.layer.masksToBounds = YES;
    self.publishedBtn.layer.cornerRadius = 5.0;
    self.publishedBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.publishedBtnWith.constant = 60 *ProportionAdapter;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)selectAllBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectAll];
    }
}
- (IBAction)publishedBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate publisBtn];
    }
}


@end
