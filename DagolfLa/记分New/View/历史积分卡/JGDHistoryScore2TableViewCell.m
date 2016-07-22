

//
//  JGDHistoryScore2TableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDHistoryScore2TableViewCell.h"

@interface JGDHistoryScore2TableViewCell ()

@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, strong) UILabel *placeLB;

@property (nonatomic, strong) UIImageView *holderImageV;

@property (nonatomic, strong) UILabel *activityNameLB;

@property (nonatomic, strong) UILabel *ballName;

@property (nonatomic, strong) UIImageView *unfinishimageV;

@end


@implementation JGDHistoryScore2TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.timeLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 0, 72 * ProportionAdapter, 65 * ProportionAdapter)];
        self.timeLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.timeLB.textColor = [UIColor colorWithHexString:@"#b8b8b8"];
        [self.contentView addSubview:self.timeLB];
        
        self.lineLimageV = [[UIImageView alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 0, 2 * ProportionAdapter, 65 * ProportionAdapter)];
        self.lineLimageV.backgroundColor = [UIColor colorWithHexString:@"#58a9be"];
        [self.contentView addSubview:self.lineLimageV];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(82 * ProportionAdapter, 25 * ProportionAdapter, 18 * ProportionAdapter, 18 * ProportionAdapter)];
        imageV.image = [UIImage imageNamed:@"dot"];
        [self.contentView addSubview:imageV];
        
        self.numberLB = [[UILabel alloc] initWithFrame:CGRectMake(110 * ProportionAdapter, 0, 60 * ProportionAdapter, 65 * ProportionAdapter)];
        [self.contentView addSubview:self.numberLB];
        
        
        
        self.holderImageV = [[UIImageView alloc] initWithFrame:CGRectMake(165 * ProportionAdapter, 10 * ProportionAdapter, 200 * ProportionAdapter, 45 * ProportionAdapter)];
        self.holderImageV.image = [UIImage imageNamed:@"yousaishi-nocolor"];
        [self.contentView addSubview:self.holderImageV];
       
        self.unfinishimageV = [[UIImageView alloc] initWithFrame:CGRectMake(200 * ProportionAdapter - 35 * ProportionAdapter, 0, 35 * ProportionAdapter, 35 * ProportionAdapter)];
        self.unfinishimageV.image = [UIImage imageNamed:@"weiwanchegn"];
        
        self.activityNameLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 10 * ProportionAdapter, 170 * ProportionAdapter, 25 * ProportionAdapter)];
        self.activityNameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        self.activityNameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.holderImageV addSubview:self.activityNameLB];
        
        self.ballName = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 10 * ProportionAdapter, 170 * ProportionAdapter, 25 * ProportionAdapter)];
        self.ballName.textColor = [UIColor colorWithHexString:@"#666666"];
        self.ballName.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [self.holderImageV addSubview:self.ballName];
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        
        
    }
    return self;
}

- (void)setModel:(JGDHistoryScoreModel *)model{
        
        self.timeLB.text = [model.createtime substringWithRange:NSMakeRange(0, 10)];
        self.ballName.text = model.ballName;
        
        NSString* strMoney = [NSString stringWithFormat:@"%@杆", [model.poleNumber stringValue]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMoney];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fe6424"] range:NSMakeRange(0, str.length - 1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#cccccc"] range:NSMakeRange(str.length - 1, 1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 * ProportionAdapter] range:NSMakeRange(0, str.length - 1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(str.length - 1, 1)];
        self.numberLB.attributedText = str;

    
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
