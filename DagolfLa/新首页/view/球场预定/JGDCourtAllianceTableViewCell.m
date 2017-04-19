//
//  JGDCourtAllianceTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDCourtAllianceTableViewCell.h"

@implementation JGDCourtAllianceTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.courtNameLB = [Helper lableRect:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, ScreenWidth - 20 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:17 * ProportionAdapter text:@"高尔夫球场" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.courtNameLB];
        
        self.serviceLB = [Helper lableRect:CGRectMake(10 * ProportionAdapter, 50 * ProportionAdapter, ScreenWidth - 20 * ProportionAdapter, 15 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:13 * ProportionAdapter text:@"service" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.serviceLB];
        
        for (int i = 0; i < 2; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter + 183 * ProportionAdapter * i, 85 * ProportionAdapter, 172 * ProportionAdapter, 140 * ProportionAdapter)];
            imageView.image = [UIImage imageNamed:@"detail_bg_ballground"];
            imageView.userInteractionEnabled = YES;
            [self.contentView addSubview:imageView];
        }
        
        self.vipPriceLB = [Helper lableRect:CGRectMake(10 * ProportionAdapter, 105 * ProportionAdapter, (ScreenWidth - 31 * ProportionAdapter) / 2, 25 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:22 * ProportionAdapter text:@"¥123" textAlignment:(NSTextAlignmentCenter)];
        [self.contentView addSubview:self.vipPriceLB];
        
        
        self.vipBtn = [[UIButton alloc] initWithFrame:CGRectMake(48.5 * ProportionAdapter, 138 * ProportionAdapter, 95 * ProportionAdapter, 55 * ProportionAdapter)];
        [self.vipBtn setImage:[UIImage imageNamed:@"booking_pay_color"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:self.vipBtn];
        
        
        self.sellPriceLB = [Helper lableRect:CGRectMake(ScreenWidth /2 + 6 * ProportionAdapter, 105 * ProportionAdapter, (ScreenWidth - 31 * ProportionAdapter) / 2, 25 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:22 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentCenter)];
        [self.contentView addSubview:self.sellPriceLB];
        
        // 原价
        self.originalPriceLB = [Helper lableRect:CGRectMake(ScreenWidth /2 + 6 * ProportionAdapter, 105 * ProportionAdapter, (ScreenWidth - 31 * ProportionAdapter) / 2, 25 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:11 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.originalPriceLB];
        
        self.normalBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 2 + 44 * ProportionAdapter, 138 * ProportionAdapter, 95 * ProportionAdapter, 55 * ProportionAdapter)];
        [self.normalBtn setImage:[UIImage imageNamed:@"booking_pay_norcolor"] forState:(UIControlStateNormal)];
        [self.normalBtn setTitleColor:[UIColor colorWithHexString:@"#fc5a01"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:self.normalBtn];
        self.normalBtn.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
//        [self.normalBtn setTitleEdgeInsets:UIEdgeInsetsMake(30 * ProportionAdapter, -95 * ProportionAdapter, 0, 0)];

        self.normalLB = [Helper lableRect:CGRectMake(0, 23 * ProportionAdapter, 95 * ProportionAdapter, 35 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:15 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentCenter)];
        [self.normalBtn addSubview:self.normalLB];
        
        
//        self.remainderBallLB = [Helper lableRect:CGRectMake(10 * ProportionAdapter, 202 * ProportionAdapter, 170 * ProportionAdapter, 15 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:11 * ProportionAdapter text:@"年度剩余可预定球位数：0位" textAlignment:(NSTextAlignmentCenter)];
//        [self.contentView addSubview:self.remainderBallLB];
        
        UILabel *lineLB = [Helper lableRect:CGRectMake(0, 239.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:1 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:lineLB];
        
    }
    return self;
}



- (void)setDataDic:(NSMutableDictionary *)dataDic{
    
    self.courtNameLB.text = [dataDic objectForKey:@"bookName"];
    self.serviceLB.text = [dataDic objectForKey:@"servicePj"];
    
    
//    NSMutableAttributedString *remainderStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"年度剩余可预订球位数：%@位", [dataDic objectForKey:@"remoteRemainingNumber"]]];
//    NSString *lengthStr = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"remoteRemainingNumber"]];
//    [remainderStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 * ProportionAdapter] range:NSMakeRange(11, lengthStr.length)];
//    // 颜色
//    [remainderStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#626262"] range:NSMakeRange(11, lengthStr.length)];
//
//    self.remainderBallLB.attributedText = remainderStr;
    
    
    NSMutableAttributedString *leagueStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", self.leagueMoney]];
    [leagueStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 * ProportionAdapter] range:NSMakeRange(0, 1)];
    self.vipPriceLB.attributedText = leagueStr;
    
    if (!self.hasUserCard) {
        self.vipPriceLB.text = @"***";
        [self.vipBtn setImage:[UIImage imageNamed:@"booking_pay_nocolor"] forState:(UIControlStateNormal)];
    }else{
        self.vipPriceLB.textColor = [UIColor colorWithHexString:@"#dd0a14"];
        [self.vipBtn setImage:[UIImage imageNamed:@"booking_pay_color"] forState:(UIControlStateNormal)];
    }
    
    // payType  支付类型设置 0: 全额预付  1: 部分预付  2: 球场现付
    if (self.payType == 2) {
        self.normalLB.text = @"球场现付";
        
    }else if (self.payType == 1) {
        self.normalLB.text = @"部分预付";
        
    }else{
        self.normalLB.text = @"全额预付";
        
    }

    
    if (self.deductionMoney) {
        // 立减优惠

        // 优惠后价格
        CGFloat sellWidth = [Helper textWidthFromTextString:[NSString stringWithFormat:@"¥ %@",self.payMoney] height:screenWidth - 20 * ProportionAdapter fontSize:22 * ProportionAdapter];

        NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", self.payMoney]];
        [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 * ProportionAdapter] range:NSMakeRange(0, 1)];
        self.sellPriceLB.attributedText = mutaStr;
        [self.sellPriceLB setFrame:CGRectMake(ScreenWidth /2 + 35 * ProportionAdapter, 105 * ProportionAdapter, sellWidth, 25 * ProportionAdapter)];
        
        // 优惠前价格
        
        CGFloat width = [Helper textWidthFromTextString:[NSString stringWithFormat:@"¥ %@",self.unitPrice] height:screenWidth - 20 * ProportionAdapter fontSize:11 * ProportionAdapter];
        
        UILabel *lineLB = [Helper lableRect:CGRectMake(self.sellPriceLB.frame.origin.x + self.sellPriceLB.frame.size.width + 5 * ProportionAdapter , 119.5 * ProportionAdapter, width + 10 * ProportionAdapter, 1 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [self.contentView addSubview:lineLB];
        self.originalPriceLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        self.originalPriceLB.text = [NSString stringWithFormat:@"¥ %@",self.unitPrice];
        [self.originalPriceLB setFrame:CGRectMake(self.sellPriceLB.frame.origin.x + self.sellPriceLB.frame.size.width + 10 * ProportionAdapter, 107 * ProportionAdapter, (ScreenWidth - 31 * ProportionAdapter) / 2, 25 * ProportionAdapter)];
        

    }else{
        
        // 无立减优惠

        NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", self.unitPrice]];
        [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 * ProportionAdapter] range:NSMakeRange(0, 1)];
        self.sellPriceLB.attributedText = mutaStr;
        [self.contentView addSubview:self.sellPriceLB];
    }
    
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
