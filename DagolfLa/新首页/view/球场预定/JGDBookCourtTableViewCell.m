//
//  JGDBookCourtTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDBookCourtTableViewCell.h"

@interface JGDBookCourtTableViewCell ()

@property (nonatomic , strong) UIImageView *iconImageView;

@property (nonatomic , strong) UILabel *courtBallname;

@property (nonatomic , strong) UILabel *styleANDcount;

@property (nonatomic, strong) UILabel *adressLB;

@property (nonatomic, strong) UILabel *priceLB;

@property (nonatomic, strong) UILabel *distanceLB;

@end


@implementation JGDBookCourtTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, 70 * ProportionAdapter, 70 * ProportionAdapter)];
        self.iconImageView.layer.cornerRadius = 6 * ProportionAdapter;
        self.iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        self.courtBallname = [[UILabel alloc] initWithFrame:CGRectMake(93 * ProportionAdapter, 12 * ProportionAdapter, 260 * ProportionAdapter, 20 * ProportionAdapter)];
        self.courtBallname.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
        self.courtBallname.textColor = [UIColor colorWithHexString:@"#313131"];
        [self.contentView addSubview:self.courtBallname];

        self.styleANDcount = [[UILabel alloc] initWithFrame:CGRectMake(93 * ProportionAdapter, 40 * ProportionAdapter, 200 * ProportionAdapter, 15 * ProportionAdapter)];
        self.styleANDcount.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
        self.styleANDcount.textColor = [UIColor colorWithHexString:@"#626262"];
        [self.contentView addSubview:self.styleANDcount];
        
        UIImageView *cityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(93 * ProportionAdapter,  60 * ProportionAdapter, 12 * ProportionAdapter, 18 * ProportionAdapter)];
        cityIcon.image = [UIImage imageNamed:@"address"];
        [self.contentView addSubview:cityIcon];

        self.adressLB = [[UILabel alloc] initWithFrame:CGRectMake(113 * ProportionAdapter, 60 * ProportionAdapter, 160 * ProportionAdapter, 20 * ProportionAdapter)];
        self.adressLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        self.adressLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [self.contentView addSubview:self.adressLB];
        
        self.distanceLB = [[UILabel alloc] initWithFrame:CGRectMake(self.adressLB.frame.origin.x + self.adressLB.frame.size.width + 15 * ProportionAdapter, 60 * ProportionAdapter, 60 * ProportionAdapter, 20 * ProportionAdapter)];
        self.distanceLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        self.distanceLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [self.contentView addSubview:self.distanceLB];
        
        self.priceLB = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 80 * ProportionAdapter, 0, 70 * ProportionAdapter, 90 * ProportionAdapter)];
        self.priceLB.textAlignment = NSTextAlignmentRight;
        self.priceLB.textColor = [UIColor colorWithHexString:@"#fc5a01"];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"¥78900"];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 * ProportionAdapter] range:NSMakeRange(0, 1)];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17 * ProportionAdapter] range:NSMakeRange(1, [attri length] - 1)];
        self.priceLB.attributedText = attri;
        [self.contentView addSubview:self.priceLB];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 89.5 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 0.5 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}


- (void)setModel:(JGDCourtModel *)model{
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/ball/%@_main.jpg@_2o", model.timeKey]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    self.courtBallname.text = model.ballName;
    
    self.styleANDcount.text = [NSString stringWithFormat:@"%@ | %@洞", model.type, model.holesSum];
    
    self.adressLB.text = model.address;

    CGFloat addresWidth = [Helper textWidthFromTextString:model.address height:20 * ProportionAdapter fontSize:13 * ProportionAdapter];
    CGFloat distanWidth = [Helper textWidthFromTextString:[NSString stringWithFormat:@"%@千米", model.distance] height:20 * ProportionAdapter fontSize:13 * ProportionAdapter];

    if (distanWidth + addresWidth < 177 * ProportionAdapter) {
        self.adressLB.frame = CGRectMake(113 * ProportionAdapter, 60 * ProportionAdapter, addresWidth, 20 * ProportionAdapter);
        self.distanceLB.frame = CGRectMake(113 * ProportionAdapter + addresWidth + 15 * ProportionAdapter, 60 * ProportionAdapter, distanWidth, 20 * ProportionAdapter);
    }else{
        self.adressLB.frame = CGRectMake(113 * ProportionAdapter, 60 * ProportionAdapter, 177 * ProportionAdapter - distanWidth - 15 * ProportionAdapter, 20 * ProportionAdapter);
        self.distanceLB.frame = CGRectMake(113 * ProportionAdapter + (177 * ProportionAdapter - distanWidth - 15 * ProportionAdapter), 60 * ProportionAdapter, distanWidth, 20 * ProportionAdapter);
    }
    
    self.distanceLB.text = [NSString stringWithFormat:@"%@千米", model.distance];
    
    if (model.instapaper == 2) {
        self.priceLB.text = @"封场";
    }else{
        NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", model.unitPrice]];
        [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 * ProportionAdapter] range:NSMakeRange(0, 1)];
        self.priceLB.attributedText = mutaStr;
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
