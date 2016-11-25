//
//  JGScanAddTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/11/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGScanAddTableViewCell.h"

@implementation JGScanAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 17 * ProportionAdapter, screenWidth, 50 * ProportionAdapter)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        
        UIImageView *scanImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 10 * ProportionAdapter, 30 * ProportionAdapter, 30 * ProportionAdapter)];
        scanImageV.image = [UIImage imageNamed:@"saomaGreen"];
        [whiteView addSubview:scanImageV];
        
        UILabel *textLB = [[UILabel alloc] initWithFrame:CGRectMake(75 * ProportionAdapter, 15 * ProportionAdapter, 100 , 20 * ProportionAdapter)];
        textLB.text = @"扫描添加";
        textLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        textLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [whiteView addSubview:textLB];
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
