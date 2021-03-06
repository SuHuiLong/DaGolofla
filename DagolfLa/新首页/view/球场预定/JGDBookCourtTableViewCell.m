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

@property (nonatomic, strong) UIImageView *signImageView;

@property (nonatomic , strong) UILabel *courtBallname;

@property (nonatomic , strong) UILabel *styleANDcount;

@property (nonatomic, strong) UILabel *adressLB;

@property (nonatomic, strong) UILabel *priceLB;

@property (nonatomic, strong) UILabel *distanceLB;

@property (nonatomic, strong) UIButton *fullCutBtn; // 满减

@end


@implementation JGDBookCourtTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, 70 * ProportionAdapter, 70 * ProportionAdapter)];
        self.iconImageView.layer.cornerRadius = 6 * ProportionAdapter;
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.iconImageView];
        
        self.signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(43 * ProportionAdapter, 0, 27 * ProportionAdapter, 27 * ProportionAdapter)];
        self.signImageView.image = [UIImage imageNamed:@"icn_team"];
        [self.iconImageView addSubview:self.signImageView];

        self.courtBallname = [[UILabel alloc] initWithFrame:CGRectMake(93 * ProportionAdapter, 12 * ProportionAdapter, 260 * ProportionAdapter, 20 * ProportionAdapter)];
        self.courtBallname.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
        self.courtBallname.textColor = [UIColor colorWithHexString:@"#313131"];
        [self.contentView addSubview:self.courtBallname];

        self.styleANDcount = [[UILabel alloc] initWithFrame:CGRectMake(93 * ProportionAdapter, 40 * ProportionAdapter, 200 * ProportionAdapter, 15 * ProportionAdapter)];
        self.styleANDcount.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
        self.styleANDcount.textColor = [UIColor colorWithHexString:@"#626262"];
        [self.contentView addSubview:self.styleANDcount];
        
        UIImageView *cityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(93 * ProportionAdapter,  62 * ProportionAdapter, 10 * ProportionAdapter, 15 * ProportionAdapter)];
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
        
        self.fullCutBtn = [[UIButton alloc] initWithFrame:CGRectMake(290 * ProportionAdapter, 60 * ProportionAdapter, 75 * ProportionAdapter, 20 * ProportionAdapter)];
        [self.fullCutBtn setTitle:@"¥ 0" forState:(UIControlStateNormal)];
        self.fullCutBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.fullCutBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5 * ProportionAdapter, 0, 0)];
        [self.fullCutBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * ProportionAdapter)];
        [self.fullCutBtn setImage:[UIImage imageNamed:@"icn_fullcut"] forState:(UIControlStateNormal)];
        [self.fullCutBtn setTitleColor:[UIColor colorWithHexString:@"#fc5a01"] forState:(UIControlStateNormal)];
        self.fullCutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:self.fullCutBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 89.5 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 0.5 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}


- (void)setModel:(JGDCourtModel *)model{
    
    if ([model.isLeague integerValue] == 1) {
        [self.signImageView setHidden:NO];
    }else{
        [self.signImageView setHidden:YES];
    }

//    NSString *headUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/bookball/%@.jpg", model.timeKey];
//    [[SDImageCache sharedImageCache] removeImageForKey:headUrl fromDisk:YES];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://imgcache.dagolfla.com/bookball/%@.jpg", model.timeKey]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    self.courtBallname.text = model.bookName;
    
    self.styleANDcount.text = [NSString stringWithFormat:@"%@ | %@洞", model.type, model.holesSum];
    
    self.adressLB.text = model.address;

    CGFloat addresWidth = [Helper textWidthFromTextString:model.address height:20 * ProportionAdapter fontSize:13 * ProportionAdapter];
    CGFloat distanWidth = [Helper textWidthFromTextString:[NSString stringWithFormat:@"%.1fkm", [model.distance floatValue]] height:20 * ProportionAdapter fontSize:13 * ProportionAdapter];

    if (distanWidth + addresWidth  + 15 * ProportionAdapter < 185 * ProportionAdapter) {
        self.adressLB.frame = CGRectMake(113 * ProportionAdapter, 60 * ProportionAdapter, addresWidth, 20 * ProportionAdapter);
        self.distanceLB.frame = CGRectMake(113 * ProportionAdapter + addresWidth + 15 * ProportionAdapter, 60 * ProportionAdapter, distanWidth, 20 * ProportionAdapter);
    }else{
        self.adressLB.frame = CGRectMake(113 * ProportionAdapter, 60 * ProportionAdapter, 185 * ProportionAdapter - distanWidth - 15 * ProportionAdapter, 20 * ProportionAdapter);
        self.distanceLB.frame = CGRectMake(113 * ProportionAdapter + (185 * ProportionAdapter - distanWidth - 15 * ProportionAdapter), 60 * ProportionAdapter, distanWidth, 20 * ProportionAdapter);
    }
    
    self.distanceLB.text = [NSString stringWithFormat:@"%.1fkm", [model.distance floatValue]];
    
    if (model.instapaper == 2) {
        self.priceLB.text = @"已封场";
    }else{
        NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", model.unitPrice]];
        [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 * ProportionAdapter] range:NSMakeRange(0, 1)];
        self.priceLB.attributedText = mutaStr;
    }
    
    
    if (model.deductionMoney) {
        self.fullCutBtn.hidden = NO;
        [self.fullCutBtn setTitle:[NSString stringWithFormat:@"¥ %@", model.deductionMoney] forState:(UIControlStateNormal)];

        NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %td", [model.unitPrice integerValue] + [model.deductionMoney integerValue]]];
        [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 * ProportionAdapter] range:NSMakeRange(0, 1)];
        self.priceLB.attributedText = mutaStr;
        
    }else{
        self.fullCutBtn.hidden = YES;
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
