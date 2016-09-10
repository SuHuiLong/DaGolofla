//
//  JGHScoreAreaCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoreAreaCell.h"

@implementation JGHScoreAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.areaNameBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.areaNameBtnLeft.constant = 10 *ProportionAdapter;
    
    self.areaImageViewLeft.constant = 13 *ProportionAdapter;
    
    self.blueLable.layer.masksToBounds = YES;
    self.blueLable.backgroundColor = [UIColor colorWithHexString:@"#3586d8"];
    self.blueLableRight.constant = 5 *ProportionAdapter;
    self.blueLableW.constant = 13 *ProportionAdapter;
    self.blueLable.layer.cornerRadius = self.blueLable.frame.size.width /2;
    
    self.redParLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.redParLabelRight.constant = 18 *ProportionAdapter;
    
    self.redPar.font = [UIFont systemFontOfSize:10 *ProportionAdapter];
    
    self.ligParLable.layer.masksToBounds = YES;
    self.ligParLable.backgroundColor = [UIColor colorWithHexString:@"#b4b3b3"];
    self.ligParLableW.constant = 13 *ProportionAdapter;
    self.ligParLable.layer.cornerRadius = self.blueLable.frame.size.width /2;
    
    
    self.addLable.layer.masksToBounds = YES;
    self.addLable.backgroundColor = [UIColor colorWithHexString:@"#e8625a"];
    self.addLableW.constant = 13 *ProportionAdapter;
    self.addLable.layer.cornerRadius = self.blueLable.frame.size.width /2;
    
    self.addLableRight.constant = 5 *ProportionAdapter;
    
    self.addParLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.addaddParLable.font = [UIFont systemFontOfSize:10 *ProportionAdapter];
}

- (void)configArea:(NSString *)areaString andImageDirection:(NSInteger)direction{
    [self.areaNameBtn setTitle:areaString forState:UIControlStateNormal];
    if (direction == 0) {
        self.areaImageView.image = [UIImage imageNamed:@")-1"];
    }else{
        self.areaImageView.image = [UIImage imageNamed:@")"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)areaNameBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate oneAreaNameBtn:sender];
    }
}

@end
