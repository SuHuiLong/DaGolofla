//
//  JGDCheckScoreTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCheckScoreTableViewCell.h"

@interface JGDCheckScoreTableViewCell ()


@end

@implementation JGDCheckScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.scoreLB = [[UILabel alloc] initWithFrame:CGRectMake(100 * ProportionAdapter, 14 * ProportionAdapter, screenWidth - 200 * ProportionAdapter, 15 * ProportionAdapter)];
        self.scoreLB.textAlignment = NSTextAlignmentCenter;
        self.scoreLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        [self.contentView addSubview:self.scoreLB];
        
        UIImageView *picImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 32 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 35 * ProportionAdapter)];
        picImageV.image = [UIImage imageNamed:@"vs_title"];
        [self.contentView addSubview:picImageV];
        
        self.leftLB = [[UILabel alloc] initWithFrame:CGRectMake(5 * ProportionAdapter, 10 * ProportionAdapter, 130 * ProportionAdapter, 20 * ProportionAdapter)];
        self.leftLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.leftLB.textColor = [UIColor whiteColor];
        self.leftLB.textAlignment = NSTextAlignmentCenter;
        [picImageV addSubview:self.leftLB];
        
        self.rightLB = [[UILabel alloc] initWithFrame:CGRectMake(220 * ProportionAdapter, 10 * ProportionAdapter, 130 * ProportionAdapter, 20 * ProportionAdapter)];
        self.rightLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.rightLB.textAlignment = NSTextAlignmentCenter;
        self.rightLB.textColor = [UIColor whiteColor];
        [picImageV addSubview:self.rightLB];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
