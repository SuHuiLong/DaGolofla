//
//  JGDCustomAwardTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 2017/4/26.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDCustomAwardTableViewCell.h"

@implementation JGDCustomAwardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(13), kHorizontal(16), kWvertical(17), kHvertical(17)) Image:[UIImage imageNamed:@""]];
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLB = [Helper lableRect:CGRectMake(kWvertical(39), 0, kWvertical(65), self.contentView.frame.size.height) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:kHorizontal(15) text:@"" textAlignment:(NSTextAlignmentRight)];
        [self.contentView addSubview:self.titleLB];
        
        self.inputTF = [[UITextField alloc] initWithFrame:CGRectMake(kWvertical(117), 0, kWvertical(230), self.contentView.frame.size.height)];
        self.inputTF.font = [UIFont systemFontOfSize:kHorizontal(15)];
        [self.contentView addSubview:self.inputTF];
        
        self.lineLB = [Helper lableRect:CGRectMake(0, 0, screenWidth, 1) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:kHorizontal(15) text:@"" textAlignment:(NSTextAlignmentRight)];
        self.lineLB.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.contentView addSubview:self.lineLB];
        
    }
    return self;
}

- (void)setRowHeight:(CGFloat)rowHeight{
    self.titleLB.frame = CGRectMake(kWvertical(39), 0, kWvertical(65), rowHeight);
    self.inputTF.frame = CGRectMake(kWvertical(117), 0, kWvertical(230), rowHeight);
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
