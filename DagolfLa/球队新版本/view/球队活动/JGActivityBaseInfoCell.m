//
//  JGActivityBaseInfoCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGActivityBaseInfoCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGActivityBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGTeamAcitivtyModel:(JGTeamAcitivtyModel *)model{
    //活动名称
//    @property (weak, nonatomic) IBOutlet UILabel *name;
    self.name.text = model.name;
    
    //活动地址
//    @property (weak, nonatomic) IBOutlet UILabel *address;
    self.address.text = model.ballName;
    
    //活动日期
//    @property (weak, nonatomic) IBOutlet UILabel *time;
    self.time.text = [Helper returnDateformatString:model.beginDate];
    
    //活动费用
//    @property (weak, nonatomic) IBOutlet UILabel *member;
    self.member.text = [NSString stringWithFormat:@"%.2f", [model.memberPrice floatValue]];
    
    //嘉宾费用
//    @property (weak, nonatomic) IBOutlet UILabel *guest;
    self.guest.text = [NSString stringWithFormat:@"%.2f", [model.guestPrice floatValue]];
}

@end
