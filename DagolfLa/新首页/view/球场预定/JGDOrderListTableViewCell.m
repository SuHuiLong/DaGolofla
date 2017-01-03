//
//  JGDOrderListTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/12/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDOrderListTableViewCell.h"

@interface JGDOrderListTableViewCell ()

@property (nonatomic, strong) UILabel *nameLB;          //球场名
@property (nonatomic, strong) UILabel *begainLB;
@property (nonatomic, strong) UILabel *sumPeopleLB;
@property (nonatomic, strong) UILabel *sumPriceLB;

@property (nonatomic, strong) UILabel *begainTimeLB;    // 开球时间
@property (nonatomic, strong) UILabel *sumPeopleNumLB;  // 总人数
@property (nonatomic, strong) UILabel *sumPriceNumLB;   // 总价

@property (nonatomic, strong) UILabel *payStyleLB;      // 付款方式

@property (nonatomic, strong) UILabel *payStateLB;    //  支付状态

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JGDOrderListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 20  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.nameLB];
        
        
        self.begainLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 33 * ProportionAdapter, 80  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(15 * ProportionAdapter) text:@"开球时间：" textAlignment:(NSTextAlignmentRight)];
        [self.contentView addSubview:self.begainLB];
        
        
        self.sumPeopleLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 56 * ProportionAdapter, 80  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(15 * ProportionAdapter) text:@"订单人数：" textAlignment:(NSTextAlignmentRight)];
        [self.contentView addSubview:self.sumPeopleLB];
        
        self.sumPriceLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 80 * ProportionAdapter, 80  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:(15* ProportionAdapter) text:@"订单总价：" textAlignment:(NSTextAlignmentRight)];
        [self.contentView addSubview:self.sumPriceLB];
        
        self.begainTimeLB = [self lablerect:CGRectMake(90 * ProportionAdapter, 33 * ProportionAdapter, screenWidth - 110  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(15 * ProportionAdapter) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.begainTimeLB];
        
        self.sumPeopleNumLB = [self lablerect:CGRectMake(90 * ProportionAdapter, 56 * ProportionAdapter, screenWidth - 110  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(15 * ProportionAdapter) text:@"0人" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.sumPeopleNumLB];
        
        self.sumPriceNumLB = [self lablerect:CGRectMake(90 * ProportionAdapter, 80 * ProportionAdapter, 60  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:(15 * ProportionAdapter) text:@"¥0" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.sumPriceNumLB];
        
        self.payStyleLB = [self lablerect:CGRectMake(150 * ProportionAdapter, 80 * ProportionAdapter, 80  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(15 * ProportionAdapter) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.payStyleLB];

        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 111.5, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter)];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [self.contentView addSubview:self.lineView];
        
        self.payStateLB = [self lablerect:CGRectMake(285 * ProportionAdapter, 50 * ProportionAdapter, 80  * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:(17 * ProportionAdapter) text:@"" textAlignment:(NSTextAlignmentRight)];
        [self.contentView addSubview:self.payStateLB];
        
        UILabel *lineLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 111.5, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:1 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:lineLB];

    }
    return self;
}


- (void)setDataDic:(NSDictionary *)dataDic{
    
    self.nameLB.text = [dataDic objectForKey:@"ballName"];
    self.begainTimeLB.text = [dataDic objectForKey:@"teeTime"];
    self.sumPeopleNumLB.text = [NSString stringWithFormat:@"%@人", [dataDic objectForKey:@"userSum"]];
    self.sumPriceNumLB.text = [NSString stringWithFormat:@"¥%@", [dataDic objectForKey:@"money"]];
    
    if ([[dataDic objectForKey:@"payType"] integerValue] == 0) {
        self.payStyleLB.text = @"全额预付";
    }else if ([[dataDic objectForKey:@"payType"] integerValue] == 1) {
        self.payStyleLB.text = @"部分预付";
    }else if ([[dataDic objectForKey:@"payType"] integerValue] == 2) {
        self.payStyleLB.text = @"球场现付";
    }
    
    
    NSString *stateString = [dataDic objectForKey:@"stateShowString"];
    self.payStateLB.text = stateString;

    if ([@"订单失效已完成" containsString:stateString]) {
        [self.payStateLB setTextColor:[UIColor colorWithHexString:@"#a0a0a0"]];

    }else{
        [self.payStateLB setTextColor:[UIColor colorWithHexString:@"#fc5a01"]];

    }
    
    // 订单状态  0: 待付款  1:待确认  3: 待取消  4: 待退款  5: 已完成  6: 已关闭 
//    if ([[dataDic objectForKey:@"state"] integerValue] == 0) {
//        self.payStateLB.text = @"待付款";
//        
//    }else if ([[dataDic objectForKey:@"state"] integerValue] == 1) {
//        self.payStateLB.text = @"待确认";
//
//    }else if ([[dataDic objectForKey:@"state"] integerValue] == 3) {
//        self.payStateLB.text = @"待取消";
//
//    }else if ([[dataDic objectForKey:@"state"] integerValue] == 4) {
//        self.payStateLB.text = @"待退款";
//
//    }else if ([[dataDic objectForKey:@"state"] integerValue] == 5) {
//        self.payStateLB.text = @"已完成";
//
//    }else if ([[dataDic objectForKey:@"state"] integerValue] == 6) {
//        self.payStateLB.text = @"已关闭";
//        [self.payStateLB setTextColor:[UIColor colorWithHexString:@"#a0a0a0"]];
//    }
}

//  封装cell方法
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    return label;
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
