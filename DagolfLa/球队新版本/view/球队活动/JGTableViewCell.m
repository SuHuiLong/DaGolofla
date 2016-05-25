//
//  JGTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTableViewCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)configTitlesString:(NSString *)titles{
    self.titles.text = titles;
}

- (void)configContionsString:(NSString *)contions{
    self.contions.text = contions;
}
- (void)configContionsStringWhitModel:(JGTeamAcitivtyModel *)model andIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.section);
    NSLog(@"%ld", (long)indexPath.row);
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            self.contions.text = model.beginDate;//活动开始时间
        }else if (indexPath.row == 1){
            self.contions.text = model.endDate;//活动结束时间
        }else{
            self.contions.text = model.signUpEndTime;//报名截止时间
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            self.contions.text = [NSString stringWithFormat:@"%ld/%ld", (long)model.memberPrice, (long)model.guestPrice];//费用说明
        }else if (indexPath.row == 1){
            self.contions.text = [NSString stringWithFormat:@"%ld(人)", (long)model.maxCount];
        }else{
            self.contions.text = model.info;
        }
    }
    
    
}

- (void)configJGTeamAcitivtyModel:(JGTeamAcitivtyModel *)model andIndecPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        self.contions.text = model.name;
    }else if (indexPath.row == 1){
        self.contions.text = model.name;
    }else if (indexPath.row == 2){
        self.contions.text = model.name;
    }else if (indexPath.row == 3){
        self.contions.text = model.name;
    }else if (indexPath.row == 4){
        self.contions.text = model.name;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
