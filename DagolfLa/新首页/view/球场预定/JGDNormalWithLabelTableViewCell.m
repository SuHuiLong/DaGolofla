//
//  JGDNormalWithLabelTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDNormalWithLabelTableViewCell.h"

@implementation JGDNormalWithLabelTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLB = [Helper lableRect:CGRectMake(0, 0, screenWidth, _cellHeight) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:15 * ProportionAdapter text:@"劳劳碌碌哩哩啦啦" textAlignment:(NSTextAlignmentCenter)];
        self.nameLB.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:self.nameLB];
        
        self.lineLB = [Helper lableRect:CGRectMake(0, 41.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:1 text:@"" textAlignment:(NSTextAlignmentCenter)];
        self.lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:self.lineLB];
    }
    return self;
}


- (void)setCellHeight:(CGFloat)cellHeight{
    [self.nameLB setFrame:CGRectMake(0, 0, screenWidth, cellHeight)];
    [self.lineLB setFrame:CGRectMake(0, cellHeight - 0.5 * ProportionAdapter, screenWidth,0.5 * ProportionAdapter)];

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
