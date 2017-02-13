//
//  JGNewsTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGNewsTableViewCell.h"

@implementation JGNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, 80 * ProportionAdapter, 60 * ProportionAdapter)];
        [self.contentView addSubview:self.iconImageV];
        
        self.titleNewsLB = [self lablerect:CGRectMake(100 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:16 text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.titleNewsLB];
        
        self.deltailLB = [self lablerect:CGRectMake(100 * ProportionAdapter, 30 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#7f7f7f"] labelFont:13 text:@"" textAlignment:(NSTextAlignmentLeft)];
        self.deltailLB.numberOfLines = 0;
        [self.contentView addSubview:self.deltailLB];
        
        UILabel *lineLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 79 * ProportionAdapter, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#e5e5e5"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentLeft)];
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
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

@end
