//
//  JGHMatchTranscriptTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHMatchTranscriptTableViewCell.h"

@implementation JGHMatchTranscriptTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.ballName.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    self.ballNameLeft.constant = 10 *ProportionAdapter;
    self.ballNameTop.constant = 15 *ProportionAdapter;
    self.ballNameRight.constant = 10 *ProportionAdapter;

    self.timeImageLeft.constant = 10 *ProportionAdapter;
    
    self.time.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    self.timeLeft.constant = 10 *ProportionAdapter;
    self.timeDown.constant = 15 *ProportionAdapter;
    self.timeRight.constant = 10 *ProportionAdapter;

    self.setAlmostBtn.layer.masksToBounds = YES;
    self.setAlmostBtn.layer.cornerRadius = 5.0;
    [self.setAlmostBtn.layer setBorderWidth:1.0];
    [self.setAlmostBtn.layer setBorderColor:([UIColor colorWithHexString:@"#5DACF7"]).CGColor];
    self.setAlmostBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    
    NSLayoutConstraint *wConstraint = [NSLayoutConstraint constraintWithItem:self.setAlmostBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0*ProportionAdapter];
    NSArray *arrayW = [NSArray arrayWithObjects:wConstraint, nil];
    [self addConstraints:arrayW];
    
    self.setAlmostBtnRight.constant = 10 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setAlmostBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectSetAlmostBtn];
    }
}

- (void)configActivityName:(NSString *)name andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    self.ballName.text = name;
    
    self.time.text = [NSString stringWithFormat:@"%@~%@", [[startTime componentsSeparatedByString:@" "] firstObject], [[endTime componentsSeparatedByString:@" "] firstObject]];
}

@end
