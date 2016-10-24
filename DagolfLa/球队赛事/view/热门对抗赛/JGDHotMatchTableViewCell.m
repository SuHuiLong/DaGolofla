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
@property (nonatomic, strong) UILabel *kindLB;

@end

@implementation JGDHotMatchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 赛事头像
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 6 * ProportionAdapter, 68 * ProportionAdapter, 68 * ProportionAdapter)];
        [self.contentView addSubview:self.iconImage];
        self.iconImage.layer.cornerRadius = 6 * ProportionAdapter;
        self.iconImage.clipsToBounds = YES;
        self.iconImage.backgroundColor = [UIColor orangeColor];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
        //activityStateImage
        self.identifierImage = [[UIImageView alloc] initWithFrame:CGRectMake(38 * ProportionAdapter, 0, 30 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.iconImage addSubview:self.identifierImage];
        
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(88 * ProportionAdapter, 8 * ProportionAdapter, 180 * ProportionAdapter, 25 * ProportionAdapter)];
        [self.contentView addSubview:self.titleLB];
        self.titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];

        UIImageView *dateimageV = [[UIImageView alloc] initWithFrame:CGRectMake(88 * ProportionAdapter, 38 * ProportionAdapter, 15 * ProportionAdapter, 15 * ProportionAdapter)];
        dateimageV.image = [UIImage imageNamed:@"time"];
        [self.contentView addSubview:dateimageV];
        
        UIImageView *addressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 58 * ProportionAdapter, 10 * ProportionAdapter, 15 * ProportionAdapter)];
        addressImageV.image = [UIImage imageNamed:@"address"];
        [self.contentView addSubview:addressImageV];
    
    
        self.kindLB = [[UILabel alloc] initWithFrame:CGRectMake(270 * ProportionAdapter, 12 * ProportionAdapter, 100 * ProportionAdapter, 25 * ProportionAdapter)];
        self.kindLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        self.kindLB.textColor = [UIColor colorWithHexString:@"#fe6424"];
        self.kindLB.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.kindLB];
    
        self.sumLB = [[UILabel alloc] initWithFrame:CGRectMake(270 * ProportionAdapter, 38 * ProportionAdapter, 100 * ProportionAdapter, 20 * ProportionAdapter)];
        self.sumLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.sumLB.textColor = [UIColor colorWithHexString:@"a0a0a0"];
        self.sumLB.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.sumLB];
        
        
        self.dateLB = [[UILabel alloc] initWithFrame:CGRectMake(110 * ProportionAdapter, 35 * ProportionAdapter, 100 * ProportionAdapter, 20 * ProportionAdapter)];
        self.dateLB.textColor = [UIColor colorWithHexString:@"#626262"];
        self.dateLB.font = [UIFont systemFontOfSize:10 * ProportionAdapter];
        [self.contentView addSubview:self.dateLB];
        
        self.adressLB = [[UILabel alloc] initWithFrame:CGRectMake(110 * ProportionAdapter, 55 * ProportionAdapter, 260 * ProportionAdapter, 20 * ProportionAdapter)];
        self.adressLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.adressLB.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.adressLB];
    }
    return self;
}

- (void)setModel:(JGDConfrontChannelModel *)model{
    
    
    switch ([model.state integerValue]) {
        case 10:
            self.identifierImage.image = [UIImage imageNamed:@"activityStateImage"]; // 报名中
            break;
        case 11:
            self.identifierImage.image = [UIImage imageNamed:@"list_bisai"]; // 比赛中
            break;
        case 0:
            self.identifierImage.image = [UIImage imageNamed:@"icn_weifabu"]; // 未发布
            break;

        default:
            self.identifierImage.image = [UIImage imageNamed:@""];
            break;
    }
    
    
//    if ([model.state integerValue] == 10) {
//        self.identifierImage.image = [UIImage imageNamed:@"activityStateImage"]; // 报名中
//    } else if ([model.state integerValue] == 11) {
//        self.identifierImage.image = [UIImage imageNamed:@"list_bisai"]; // 比赛中
//    } else if ([model.state integerValue] == 12) {
//        self.identifierImage.image = [UIImage imageNamed:@"icn_weifabu"]; // 未发布
//    } else{
//        self.identifierImage.image = [UIImage imageNamed:@""];
//    }
    
    
    self.adressLB.text = model.ballName;
    self.sumLB.text = [NSString stringWithFormat:@"参赛：%td 人",[model.sumCount integerValue]];
    self.kindLB.text = model.matchTypeName;
    self.titleLB.text = model.matchName;
    self.dateLB.text = [NSString stringWithFormat:@"%@月%@号",[model.beginDate substringWithRange:NSMakeRange(5, 2)], [model.beginDate substringWithRange:NSMakeRange(8, 2)]];

    //清缓存
    NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/match/%@.jpg",model.timeKey];
    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
    
    // 再给图片赋值
    [self.iconImage sd_setImageWithURL:[Helper setMatchImageIconUrl:[model.timeKey integerValue] ]placeholderImage:[UIImage imageNamed:TeamLogoImage]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
