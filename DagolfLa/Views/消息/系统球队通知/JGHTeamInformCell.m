//
//  JGHTeamInformCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTeamInformCell.h"
#import "JGHInformModel.h"

@implementation JGHTeamInformCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 *ProportionAdapter, 15 *ProportionAdapter, 0, 0)];
//        
//        self.isReadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 *ProportionAdapter, 15 *ProportionAdapter, 10 *ProportionAdapter, 10*ProportionAdapter)];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(15 *ProportionAdapter, 15 *ProportionAdapter, screenWidth -60*ProportionAdapter, 40 *ProportionAdapter)];
        self.name.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        self.name.numberOfLines = 0;
        self.name.text = @"球队通知u 十多年的南非进口你的看法就给法国的风格到逢年过节看地方能够看地方能见度开放给你空间的风格";
        self.name.textColor = [UIColor colorWithHexString:@"#313131"];
        [self addSubview:self.name];
        
//        self.teamNameLine = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 75*ProportionAdapter, 40*ProportionAdapter, 1)];
//        self.teamNameLine.backgroundColor = [UIColor colorWithHexString:@"#a0a0a0"];
//        [self addSubview:self.teamNameLine];
        
        self.teamName = [[UILabel alloc]initWithFrame:CGRectMake(15 *ProportionAdapter, 65 *ProportionAdapter, screenWidth - 175 *ProportionAdapter, 20 *ProportionAdapter)];
        self.teamName.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        self.teamName.text = @"优高客俱乐部";
        self.teamName.textAlignment = NSTextAlignmentLeft;
        self.teamName.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [self addSubview:self.teamName];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth -110 *ProportionAdapter, 65 *ProportionAdapter, 85 *ProportionAdapter, 20 *ProportionAdapter)];
        self.time.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        self.time.text = @"2016-10-23";
        self.time.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        self.time.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.time];
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

- (void)configJGHTeamInformCell:(JGHInformModel *)model{
//    CGSize titleSize = [[NSString stringWithFormat:@"    %@", model.title] boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*ProportionAdapter]} context:nil].size;
    
//    CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ProportionAdapter]} context:nil].size;
    
    if (model.linkURL) {
        
        CGSize titleSize = [[NSString stringWithFormat:@"%@", model.title] boundingRectWithSize:CGSizeMake(screenWidth - 50 * ProportionAdapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*ProportionAdapter]} context:nil].size;

        
        self.name.frame = CGRectMake(15 *ProportionAdapter, 15 *ProportionAdapter, screenWidth -50*ProportionAdapter, titleSize.height);
        
        //    self.teamNameLine.frame = CGRectMake(10 *ProportionAdapter, titleSize.height +35*ProportionAdapter, 20*ProportionAdapter, 1);
        
        self.teamName.frame = CGRectMake(15 *ProportionAdapter, titleSize.height + 25*ProportionAdapter, screenWidth -120 *ProportionAdapter, 20 *ProportionAdapter);
        
        self.time.frame = CGRectMake(screenWidth -130 *ProportionAdapter, titleSize.height + 25*ProportionAdapter, 85 *ProportionAdapter, 20 *ProportionAdapter);
    }else{
        
        CGSize titleSize = [[NSString stringWithFormat:@"%@", model.title] boundingRectWithSize:CGSizeMake(screenWidth - 30 * ProportionAdapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*ProportionAdapter]} context:nil].size;

        self.name.frame = CGRectMake(15 *ProportionAdapter, 15 *ProportionAdapter, screenWidth -30*ProportionAdapter, titleSize.height);
        
        //    self.teamNameLine.frame = CGRectMake(10 *ProportionAdapter, titleSize.height +35*ProportionAdapter, 20*ProportionAdapter, 1);
        
        self.teamName.frame = CGRectMake(15 *ProportionAdapter, titleSize.height + 25*ProportionAdapter, screenWidth -100 *ProportionAdapter, 20 *ProportionAdapter);
        
        self.time.frame = CGRectMake(screenWidth -110 *ProportionAdapter, titleSize.height + 25*ProportionAdapter, 85 *ProportionAdapter, 20 *ProportionAdapter);
    }

    
    
    self.name.text = [NSString stringWithFormat:@"%@", model.title];
    
    self.teamName.text = model.nSrcName;
    
    self.time.text = [NSString stringWithFormat:@"%@", [Helper distanceTimeWithBeforeTimeNotificat:model.createTime]];
}

@end
