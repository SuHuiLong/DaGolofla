//
//  JGHSysInformCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSysInformCell.h"
#import "JGHInformModel.h"

@implementation JGHSysInformCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 *ProportionAdapter, 15 *ProportionAdapter, 0, 0)];
        
//        self.read = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 20 *ProportionAdapter, 10 *ProportionAdapter, 10*ProportionAdapter)];
//        self.read.backgroundColor = [UIColor colorWithHexString:Bar_Color];
//        self.read.layer.masksToBounds = YES;
//        self.read.layer.cornerRadius = self.read.frame.size.width/2;
//        [self addSubview:self.read];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 15 *ProportionAdapter, screenWidth -(30 + 80)*ProportionAdapter, 20 *ProportionAdapter)];
        self.name.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        self.name.textColor = [UIColor colorWithHexString:@"#313131"];
        self.name.text = @"系统通知";
        self.name.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.name];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth -90 *ProportionAdapter, 15 *ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter)];
        self.time.textAlignment = NSTextAlignmentRight;
        self.time.font = [UIFont systemFontOfSize:12 *ProportionAdapter];
        self.time.text = @"2016-10-23";
        self.time.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [self addSubview:self.time];
        
        self.detail = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 45 *ProportionAdapter, screenWidth -20 *ProportionAdapter, 20 *ProportionAdapter)];
        self.detail.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        self.detail.numberOfLines = 0;
        self.detail.textAlignment = NSTextAlignmentLeft;
        self.detail.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        self.detail.text = @"农夫农夫就是奶粉是地方就是办公室就看到不少的身份丹江口市净空法师能看到积分榜上看见对方 那就是打开妇女健康是否能看见是地方暖色调肌肤是你看地方";
        [self addSubview:self.detail];
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

- (void)configJGHSysInformCell:(JGHInformModel *)model{
//    CGSize titleSize = [model.title boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*ProportionAdapter]} context:nil].size;
    
    
//    self.name.frame = CGRectMake(10 *ProportionAdapter, 15 *ProportionAdapter, screenWidth -20*ProportionAdapter, titleSize.height);
    
//    self.detail.frame = CGRectMake(10 *ProportionAdapter, titleSize.height + 30*ProportionAdapter, screenWidth -20 *ProportionAdapter, contentSize.height);
    
    if (model.linkURL) {
        CGSize contentSize = [[NSString stringWithFormat:@"    %@", model.content] boundingRectWithSize:CGSizeMake(screenWidth -50 *ProportionAdapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ProportionAdapter]} context:nil].size;

        self.detail.frame = CGRectMake(10 *ProportionAdapter, 45 *ProportionAdapter, screenWidth -50 *ProportionAdapter, contentSize.height);

    }else{
        CGSize contentSize = [[NSString stringWithFormat:@"    %@", model.content] boundingRectWithSize:CGSizeMake(screenWidth -30 *ProportionAdapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ProportionAdapter]} context:nil].size;

        self.detail.frame = CGRectMake(10 *ProportionAdapter, 45 *ProportionAdapter, screenWidth -30 *ProportionAdapter, contentSize.height);

    }
    self.name.text = [NSString stringWithFormat:@"%@", model.title];
    
    self.time.text = [NSString stringWithFormat:@"%@", [Helper distanceTimeWithBeforeTime:model.createTime]];
    
    self.detail.text = [NSString stringWithFormat:@"    %@", model.content];
}


@end
