//
//  JGHChooseAwardCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHChooseAwardCell.h"
#import "JGHAwardModel.h"

@implementation JGHChooseAwardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chooseBtnClick:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate selectChooseAwardBtnClick:sender];
    }
}

-(void)configJGHAwardModel:(JGHAwardModel *)model{
    self.jiangbeiLeft.constant = 10 *ProportionAdapter;
    self.awardName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.awardNameLeft.constant = 10 *ProportionAdapter;
    self.chooseBtnRight.constant = 10 *ProportionAdapter;
    
    self.awardName.text = model.name;
    
    //
    [self.chooseBtn setImage:nil forState:UIControlStateNormal];
    
    if (model.select == 0) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [self.chooseBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateDisabled];

    }else{
        [self.chooseBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [self.chooseBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateDisabled];
    }

}

@end
