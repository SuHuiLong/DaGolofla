//
//  JGDPersonalTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 17/2/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDPersonalTableViewCell.h"

@implementation JGDPersonalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLB = [Helper lableRect:CGRectMake(12 * ProportionAdapter, 0, 100 * ProportionAdapter, 49 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:15 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.titleLB];
        
        self.nameLB = [Helper lableRect:CGRectMake( screenWidth - 260 * ProportionAdapter, 0, 220 * ProportionAdapter , 49 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:15 * ProportionAdapter text:@"请选择" textAlignment:(NSTextAlignmentRight)];
        [self.contentView addSubview:self.nameLB];
        
        UILabel *lineLB = [Helper lableRect:CGRectMake(0, 48.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter) labelColor:[UIColor blackColor] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
        [self.contentView addSubview:lineLB];
        
    
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
