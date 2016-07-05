//
//  JGHActivityBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActivityBaseCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGHActivityBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSLayoutConstraint *sConstraint = [NSLayoutConstraint constraintWithItem:self.activityimageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:64*ProportionAdapter];
    
    NSArray *array2 = [NSArray arrayWithObjects:sConstraint, nil];
    [self addConstraints: array2];
//    @property (weak, nonatomic) IBOutlet UIImageView *activityimageView;
    self.activityimageViewLeft.constant = 10 *ProportionAdapter;

    self.nameLeft.constant = 20 *ProportionAdapter;
    self.name.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    
    self.timeLeft.constant = 20 *ProportionAdapter;
    self.timeTop.constant = 7.5 *ProportionAdapter;
    self.timeDown.constant = 7.5 *ProportionAdapter;
    
    self.timevalueLeft.constant = 8 *ProportionAdapter;
    self.timevlaue.font = [UIFont systemFontOfSize:12*ProportionAdapter];
    
    self.addressLeft.constant = 20 *ProportionAdapter;
    self.addressVlaueLeft.constant = 8 *ProportionAdapter;
    self.addressVlaue.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGTeamActivityModel:(JGTeamAcitivtyModel *)model{
    //头像
    [self.activityimageView sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:model.teamActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    //活动名称
    self.name.text = model.name;

    //活动时间componentsSeparatedByString
    NSString *timeString = [[model.beginDate componentsSeparatedByString:@" "]firstObject];
    NSString *monthTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:1];
    NSString *dataTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:2];
    self.timevlaue.text = [NSString stringWithFormat:@"%@月%@日", monthTimeString, dataTimeString];
    //活动地址
    self.addressVlaue.text = [NSString stringWithFormat:@"%@", model.ballName];
}

@end
