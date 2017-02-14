//
//  JGHConsultChannelCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHConsultChannelCell.h"

@implementation JGHConsultChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.eventBtn.titleLabel.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    self.skillBtn.titleLabel.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    self.activityBtn.titleLabel.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    self.videoBtn.titleLabel.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    
    self.oneLineTop.constant = 15 *ProportionAdapter;
    self.oneLineDown.constant = 15 *ProportionAdapter;
    
    self.twoLineTop.constant = 15 *ProportionAdapter;
    self.twoLineDown.constant = 15 *ProportionAdapter;
    
    self.threeLineTop.constant = 15 *ProportionAdapter;
    self.threeLineDown.constant = 15 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configJGHConsultChannelCell:(NSInteger)showId{
    [self.eventBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.skillBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.activityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.videoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    if (showId == 0) {
        [self.eventBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (showId == 1){
        [self.skillBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (showId == 2){
        [self.activityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark -- 赛事
- (IBAction)eventBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectJGHConsultChannelCellBtnClick:)]) {
        [self.delegate didSelectJGHConsultChannelCellBtnClick:sender];
    }
}
#pragma mark -- 球技
- (IBAction)skillBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectJGHConsultChannelCellBtnClick:)]) {
        [self.delegate didSelectJGHConsultChannelCellBtnClick:sender];
    }
}
#pragma mark -- 活动
- (IBAction)activityBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectJGHConsultChannelCellBtnClick:)]) {
        [self.delegate didSelectJGHConsultChannelCellBtnClick:sender];
    }
}
#pragma mark -- 视频
- (IBAction)videoBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectJGHConsultChannelCellBtnClick:)]) {
        [self.delegate didSelectJGHConsultChannelCellBtnClick:sender];
    }
}
@end
