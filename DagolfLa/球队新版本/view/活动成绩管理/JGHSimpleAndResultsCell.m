//
//  JGHSimpleAndResultsCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSimpleAndResultsCell.h"

@implementation JGHSimpleAndResultsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.titleLable.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    self.titleLableLeft.constant = 10 *ProportionAdapter;
    
    self.simpleScoreBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.simpleScoreBtnRight.constant = 20 *ProportionAdapter;
    self.simpleScoreBtnW.constant = 80 *ProportionAdapter;

    self.holeScoreBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.holeScoreBtnRight.constant = 20 *ProportionAdapter;
    self.holeScoreBtnW.constant = 90 *ProportionAdapter;
    
    self.simpleScoreBtn.layer.masksToBounds = YES;
    self.simpleScoreBtn.layer.cornerRadius = 5.0*ProportionAdapter;
    self.simpleScoreBtn.layer.borderWidth = 1.0;
    self.simpleScoreBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.holeScoreBtn.layer.masksToBounds = YES;
    self.holeScoreBtn.layer.cornerRadius = 5.0*ProportionAdapter;
    self.holeScoreBtn.layer.borderWidth = 1.0;
    self.holeScoreBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)configUIBtn:(NSInteger)btnId{
    self.simpleScoreBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.holeScoreBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if (btnId == 0) {
        self.simpleScoreBtn.layer.borderWidth = 1.0;
        self.simpleScoreBtn.layer.borderColor = [UIColor colorWithHexString:@"#3AB152"].CGColor;
    }else{
        self.holeScoreBtn.layer.borderWidth = 1.0;
        self.holeScoreBtn.layer.borderColor = [UIColor colorWithHexString:@"#3AB152"].CGColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)simpleScoreBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectSimpleScoreBtnClick:sender];
    }
}

- (IBAction)holeScoreBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleScoreBtnClick:sender];
    }
}

@end
