
//
//  JGDAlmostSetTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/9/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDAlmostSetTableViewCell.h"

@implementation JGDAlmostSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 380 * ProportionAdapter)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
    
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, 100 * ProportionAdapter, 20 * ProportionAdapter)];
        titleLB.text = @"差点设置";
        titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        titleLB.textColor = [UIColor colorWithHexString:@"#32b14d"];
        [backView addSubview:titleLB];
        
        UILabel *newCalculateLB = [[UILabel alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 40 * ProportionAdapter, 300 * ProportionAdapter, 20 * ProportionAdapter)];
        newCalculateLB.text = @"新新贝利亚算法自动计算差点";
        newCalculateLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [backView addSubview:newCalculateLB];
        
        UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(300 * ProportionAdapter, 40 * ProportionAdapter, 20 * ProportionAdapter, 20 * ProportionAdapter)];
        [newButton setImage:[UIImage imageNamed:@"yuanquan"] forState:UIControlStateNormal];
        newButton.tag = 201;
        [backView addSubview:newButton];
        
        UILabel *newCalculateDetailLB = [[UILabel alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 60 * ProportionAdapter, 300 * ProportionAdapter, 100 * ProportionAdapter)];
        newCalculateDetailLB.text = @"系统从18洞中随机抽取6个洞不计分，按新新贝利亚算法计算出每个成员当场活动的差点。补录计分时，如果采用“简单记分”未填18洞成绩，新新贝利亚算法无法计算该成员差点，需要手动添加；";
        newCalculateDetailLB.numberOfLines = 0;
        newCalculateDetailLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        newCalculateDetailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [backView addSubview:newCalculateDetailLB];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 170 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 1 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [backView addSubview:lineView];
        
        UILabel *calculateBySelfLB = [[UILabel alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 180 * ProportionAdapter, 300 * ProportionAdapter, 20 * ProportionAdapter)];
        calculateBySelfLB.text = @"采用成员自报差点";
        calculateBySelfLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [backView addSubview:calculateBySelfLB];
        
        UIButton *calculateBySelfButton = [[UIButton alloc] initWithFrame:CGRectMake(300 * ProportionAdapter, 180 * ProportionAdapter, 20 * ProportionAdapter, 20 * ProportionAdapter)];
        [calculateBySelfButton setImage:[UIImage imageNamed:@"yuanquan"] forState:UIControlStateNormal];
        calculateBySelfButton.tag = 202;
        [backView addSubview:calculateBySelfButton];
        
        UILabel *calculateBySelfDetailLB = [[UILabel alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 200 * ProportionAdapter, 300 * ProportionAdapter, 65 * ProportionAdapter)];
        calculateBySelfDetailLB.text = @"采用用队员历史差点数据或嘉宾报名时填写的差点作为当场活动的差点。如果成员无差点数据，需手动添加。";
        calculateBySelfDetailLB.numberOfLines = 0;
        calculateBySelfDetailLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        calculateBySelfDetailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [backView addSubview:calculateBySelfDetailLB];
        
        UILabel *attentionLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 270 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 100 * ProportionAdapter)];
        attentionLB.text = @"注：两种情况需要手动添加差点\na、采用成员自报差点时，如成员无差点数据，需手动添加；\nb、补录计分时如未填18洞成绩，新新贝利亚算法无法计算差点，需手动添加；";
        attentionLB.numberOfLines = 0;
        attentionLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        attentionLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
        [backView addSubview:attentionLB];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
