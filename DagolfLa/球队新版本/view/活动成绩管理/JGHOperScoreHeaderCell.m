//
//  JGHOperScoreHeaderCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOperScoreHeaderCell.h"

@implementation JGHOperScoreHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.oneAreaLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    self.oneAreaLableLeft.constant = 10 *ProportionAdapter;
    self.oneAreaLableRight.constant = 35 *ProportionAdapter;
    self.oneAreaLable.textColor = [UIColor colorWithHexString:@"#23512d"];
    self.oneAreaLable.backgroundColor = [UIColor colorWithHexString:@"#ebf3ed"];
    
    self.twoAreaLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    self.twoAreaLableRight.constant = 10 *ProportionAdapter;
    self.twoAreaLable.textColor = [UIColor colorWithHexString:@"#23512d"];
    self.twoAreaLable.backgroundColor = [UIColor colorWithHexString:@"#ebf3ed"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGHOperScoreHeaderCell:(NSString *)region1 andregion2:(NSString *)region2{
    self.oneAreaLable.layer.masksToBounds = YES;
    self.oneAreaLable.layer.cornerRadius = 5.0;
    
    self.twoAreaLable.layer.masksToBounds = YES;
    self.twoAreaLable.layer.cornerRadius = 5.0;
    
    self.oneAreaLable.text = region1;
    self.twoAreaLable.text = region2;
}

@end
