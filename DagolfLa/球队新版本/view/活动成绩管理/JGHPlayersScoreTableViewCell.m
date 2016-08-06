//
//  JGHPlayersScoreTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPlayersScoreTableViewCell.h"

@implementation JGHPlayersScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageScoreLeft.constant = 30*ProportionAdapter;
    self.imageScoreRight.constant = 30*ProportionAdapter;
   
    self.imageScoreWith.constant = 18*ProportionAdapter;
    
    self.fristLabel.font= [UIFont systemFontOfSize:15 *ProportionAdapter];

    self.twoLabel.font= [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.threeLabel.font= [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.fiveLabel.font= [UIFont systemFontOfSize:15 *ProportionAdapter];
    
}

-(void)showData:(JGLScoreLiveModel *)model
{
    self.fristLabel.textColor = [UIColor blackColor];
    self.twoLabel.textColor = [UIColor blackColor];
    self.threeLabel.textColor = [UIColor blackColor];
    self.fiveLabel.textColor = [UIColor blackColor];
    
    if (![Helper isBlankString:model.userName]) {
        self.fristLabel.text = model.userName;
    }
    else
    {
        self.fristLabel.text = @"暂无姓名";
    }
    if (model.poleNumber != nil) {
        self.twoLabel.text = [NSString stringWithFormat:@"%.f",[model.poleNumber floatValue]];
    }
    else
    {
        self.twoLabel.text = @"暂无总杆";
    }
    
    
    if (model.almost != nil) {
        self.threeLabel.text = [NSString stringWithFormat:@"%.1f",[model.almost floatValue]];
    }
    else
    {
        self.threeLabel.text = @"暂无差点";
    }
    
    if (model.netbar != nil) {
        self.fiveLabel.text = [NSString stringWithFormat:@"%.1f",[model.netbar floatValue]];
    }
    else
    {
        self.fiveLabel.text = @"暂无净杆";
    }
    
    self.imageScore.hidden = NO;
//    self.imageScore.image = nil;
    if ([model.publish integerValue] == 0) {
        self.imageScore.image = [UIImage imageNamed:@"gou_w"];
    }else{
        self.imageScore.image = [UIImage imageNamed:@"gou_x"];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectMembers:sender];
    }
}
@end
