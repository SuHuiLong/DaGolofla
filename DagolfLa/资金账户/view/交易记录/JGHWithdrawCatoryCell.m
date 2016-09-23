//
//  JGHWithdrawCatoryCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWithdrawCatoryCell.h"

@implementation JGHWithdrawCatoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.titles.font = [UIFont systemFontOfSize:17.0 * ProportionAdapter];
    self.values.font = [UIFont systemFontOfSize:15.0 * ProportionAdapter];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModelTitles:(NSString *)titles andBlankImage:(NSString *)blankImage andBlankName:(NSString *)blankName{
//    @property (weak, nonatomic) IBOutlet UILabel *titles;
    self.titles.text = titles;
    
//    @property (weak, nonatomic) IBOutlet UIImageView *blankImageView;
    self.blankImageView.image = [UIImage imageNamed:blankImage];
    
//    @property (weak, nonatomic) IBOutlet UILabel *values;
    self.values.text = blankName;
}

@end
