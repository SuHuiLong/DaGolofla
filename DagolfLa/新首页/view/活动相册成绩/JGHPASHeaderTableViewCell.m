//
//  JGHPASHeaderTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPASHeaderTableViewCell.h"

@implementation JGHPASHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.activityBtn.titleLabel.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    self.activityLableW.constant = 40 *ProportionAdapter;
    
    self.photoBtn.titleLabel.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    self.resultsBtn.titleLabel.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)activityBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectActivityOrPhotoOrResultsBtn:)]) {
        [self.delegate didSelectActivityOrPhotoOrResultsBtn:sender];
    }
}
- (IBAction)photoBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectActivityOrPhotoOrResultsBtn:)]) {
        [self.delegate didSelectActivityOrPhotoOrResultsBtn:sender];
    }
}
- (IBAction)resultsBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectActivityOrPhotoOrResultsBtn:)]) {
        [self.delegate didSelectActivityOrPhotoOrResultsBtn:sender];
    }
}

- (void)configJGHPASHeaderTableViewCell:(NSInteger)showId{
    if (showId == 0) {
        self.activityLable.hidden = NO;
        self.photoLable.hidden = YES;
        self.resultsLable.hidden = YES;
        
        [self.activityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.photoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.resultsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }else if (showId == 1){
        self.activityLable.hidden = YES;
        self.photoLable.hidden = NO;
        self.resultsLable.hidden = YES;
        
        [self.activityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.photoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.resultsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        self.activityLable.hidden = YES;
        self.photoLable.hidden = YES;
        self.resultsLable.hidden = NO;
        
        [self.activityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.photoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.resultsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

@end
