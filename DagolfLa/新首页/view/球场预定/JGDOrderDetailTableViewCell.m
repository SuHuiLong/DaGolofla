//
//  JGDOrderDetailTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/12/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDOrderDetailTableViewCell.h"

@implementation JGDOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(8 * ProportionAdapter, 0, 80 * ProportionAdapter, 22 * ProportionAdapter)];
        self.titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.titleLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        self.titleLB.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.titleLB];
        
        self.detailLB = [[UILabel alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 0, 270 * ProportionAdapter, 22 * ProportionAdapter)];
        self.detailLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.detailLB.textColor = [UIColor colorWithHexString:@"#313131"];
        [self.contentView addSubview:self.detailLB];
        self.detailLB.numberOfLines = 0;
    }
    return self;
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
