//
//  JGHOperationScoreCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOperationScoreCell.h"

@implementation JGHOperationScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.bgImage.backgroundColor = [UIColor colorWithHexString:BG_color];
//    [self.bgImage sendSubviewToBack:self];
    [self.contentView insertSubview:self.bgImage atIndex:0];
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    self.holeNameTop.constant = 65 *ProportionAdapter;
    self.holeName.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    
    self.pushNumberLeft.constant = 35 *ProportionAdapter;
    self.pushNumber.font = [UIFont systemFontOfSize:17*ProportionAdapter];

    self.pushScoreTop.constant = 50 *ProportionAdapter;
    self.pushScore.font = [UIFont systemFontOfSize:50*ProportionAdapter];

    self.addScoreBtnRight.constant = 35 *ProportionAdapter;
    self.addScoreBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];

    self.redScoreBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.scoreListBtnTop.constant = 25 *ProportionAdapter;
    self.scoreListBtnRight.constant = 30 *ProportionAdapter;
    self.scoreListBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.propmLabelLeft.constant = 15 *ProportionAdapter;
    self.propmLabelRight.constant = 15 *ProportionAdapter;
    self.propmLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configStandPar:(NSInteger)par andHole:(NSInteger)hole andPole:(NSInteger)pole{
    self.holeName.text = [NSString stringWithFormat:@"%td Hole PAR %td", hole+1, par];
    
    self.sildLeft.image = [UIImage imageNamed:@"sildLeft"];
    self.sildRight.image = [UIImage imageNamed:@"sildRight"];
    
    if (hole == 0) {
        self.sildLeft.image = [UIImage imageNamed:@"sildLefth"];
    }
    
    if (hole == 17) {
        self.sildRight.image = [UIImage imageNamed:@"sildRighth"];
    }
    
    if (pole == -1) {
        self.pushScore.text = [NSString stringWithFormat:@"%td", par];
        self.pushScore.textColor = [UIColor lightGrayColor];
    }else{
        self.pushScore.text = [NSString stringWithFormat:@"%td", pole];
        self.pushScore.textColor = [UIColor orangeColor];
    }
}



- (IBAction)addScoreBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addOperationBtn:sender];
    }
}
- (IBAction)scoreListBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate scoreListBtn:sender];
    }
}
- (IBAction)redScoreBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate redOperationBtn:sender];
    }
}
@end
