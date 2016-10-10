//
//  JGDCheckScoreTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCheckScoreTableViewCell.h"

@implementation JGDCheckScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *picImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 32 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 35 * ProportionAdapter)];
        picImageV.image = [UIImage imageNamed:@"vs_title"];
        [self.contentView addSubview:picImageV];
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
