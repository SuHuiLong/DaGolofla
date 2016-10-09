//
//  JGDHotMatchTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDHotMatchTableViewCell.h"

@interface JGDHotMatchTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIImageView *identifierImage;

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *dateLB;
@property (nonatomic, strong) UILabel *adressLB;

@property (nonatomic, strong) UILabel *sumLB;

@end

@implementation JGDHotMatchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 6 * ProportionAdapter, 68 * ProportionAdapter, 68 * ProportionAdapter)];
        [self.contentView addSubview:self.iconImage];
        self.iconImage.backgroundColor = [UIColor orangeColor];
        
        //activityStateImage
        self.identifierImage = [[UIImageView alloc] initWithFrame:CGRectMake(38 * ProportionAdapter, 0, 30 * ProportionAdapter, 30 * ProportionAdapter)];
        self.identifierImage.image = [UIImage imageNamed:@"activityStateImage"];
        [self.iconImage addSubview:self.identifierImage];
        
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(88 * ProportionAdapter, 8 * ProportionAdapter, 200 * ProportionAdapter, 25 * ProportionAdapter)];
        [self.contentView addSubview:self.titleLB];
        self.titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.titleLB.text = @"南北对抗赛";

        UIImageView *dateimageV = [[UIImageView alloc] initWithFrame:CGRectMake(88 * ProportionAdapter, 38 * ProportionAdapter, 15 * ProportionAdapter, 15 * ProportionAdapter)];
        dateimageV.image = [UIImage imageNamed:@"time"];
        [self.contentView addSubview:dateimageV];
        
        UIImageView *addressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 58 * ProportionAdapter, 10 * ProportionAdapter, 15 * ProportionAdapter)];
        addressImageV.image = [UIImage imageNamed:@"address"];
        [self.contentView addSubview:addressImageV];
    
    
        UILabel *kindLB = [[UILabel alloc] initWithFrame:CGRectMake(310 * ProportionAdapter, 12 * ProportionAdapter, 60 * ProportionAdapter, 25 * ProportionAdapter)];
        kindLB.text = @"比赛类型";
        kindLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        kindLB.textColor = [UIColor colorWithHexString:@"#fe6424"];
        [self.contentView addSubview:kindLB];
    
        self.sumLB = [[UILabel alloc] initWithFrame:CGRectMake(290 * ProportionAdapter, 40 * ProportionAdapter, 80 * ProportionAdapter, 25 * ProportionAdapter)];
        self.sumLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.sumLB.textColor = [UIColor colorWithHexString:@"a0a0a0"];
        self.sumLB.text = @"参赛：30人";
        self.sumLB.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.sumLB];
    
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
