//
//  JGTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTableViewCell.h"
#import "JGHLaunchActivityModel.h"

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
- (void)configContionsStringWhitModel:(JGHLaunchActivityModel *)model andIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.section);
    NSLog(@"%ld", (long)indexPath.row);
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            self.contions.text = model.startDate;
        }else if (indexPath.row == 1){
            self.contions.text = model.endDate;
        }else{
            self.contions.text = model.activityAddress;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            self.contions.text = model.activityInfo;
        }else if (indexPath.row == 1){
            self.contions.text = model.payInfo;
        }
    }
        
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
