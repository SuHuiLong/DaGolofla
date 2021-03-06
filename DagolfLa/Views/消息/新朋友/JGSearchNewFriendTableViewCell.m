//
//  JGSearchNewFriendTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/11/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGSearchNewFriendTableViewCell.h"

@implementation JGSearchNewFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 7 * ProportionAdapter, 48 * ProportionAdapter, 48 * ProportionAdapter)];
        self.iconImage.layer.cornerRadius = 24 * ProportionAdapter;
        self.iconImage.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImage];
        
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(73 * ProportionAdapter, 10 * ProportionAdapter, 200 * ProportionAdapter, 16 * ProportionAdapter)];
        self.nameLB.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
        [self.contentView addSubview:self.nameLB];
        
        
        self.sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(73 * ProportionAdapter , 10 * ProportionAdapter, 12 * ProportionAdapter, 12 * ProportionAdapter)];
        self.sexImage.image = [UIImage imageNamed:@"xb_n"];
        [self.contentView addSubview:self.sexImage];
        
        self.signLB = [[UILabel alloc] initWithFrame:CGRectMake(73 * ProportionAdapter, 35 * ProportionAdapter, 200 * ProportionAdapter, 14 * ProportionAdapter)];
        self.signLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
        self.signLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [self.contentView addSubview:self.signLB];
        
        self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(300 * ProportionAdapter, 15 * ProportionAdapter, 55 * ProportionAdapter, 26 * ProportionAdapter)];
        self.addBtn.layer.cornerRadius = 6 * ProportionAdapter;
        self.addBtn.clipsToBounds = YES;
        self.addBtn.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
//        [self.addBtn setTitle:@"添加" forState:(UIControlStateNormal)];
//        self.addBtn.backgroundColor = [UIColor colorWithHexString:Bar_Color];
        [self.contentView addSubview:self.addBtn];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 59.5 * ProportionAdapter, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter)];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
        [self.contentView addSubview:lineV];
        
        
    }
    return self;
}

- (void)showData:(NewFriendModel *)model{
    
    [self.iconImage sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userId integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    if (![Helper isBlankString:model.userName]) {
        self.nameLB.text = model.userName;
    }
    else
    {
        self.nameLB.text = @"暂无用户名";
    }
    
    CGFloat width = [Helper textWidthFromTextString:[NSString stringWithFormat:@"%@", self.nameLB.text] height:self.nameLB.frame.size.height fontSize:16 * ProportionAdapter];
    
    
    if (width < 185) {
        self.nameLB.frame = CGRectMake(73 * ProportionAdapter, 10 * ProportionAdapter, width, 16 * ProportionAdapter);
        self.sexImage.frame = CGRectMake(80 * ProportionAdapter + width, 12 * ProportionAdapter, 12 * ProportionAdapter, 12 * ProportionAdapter);
    }else{
        self.nameLB.frame = CGRectMake(73 * ProportionAdapter, 10 * ProportionAdapter, 185, 16 * ProportionAdapter);
        self.sexImage.frame = CGRectMake(80 * ProportionAdapter + 185, 12 * ProportionAdapter, 12 * ProportionAdapter, 12 * ProportionAdapter);
    }
    

    if ([model.sex integerValue] == 0) {
        self.sexImage.image = [UIImage imageNamed:@"xb_n"];
    }
    else
    {
        self.sexImage.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    
    if (![Helper isBlankString:model.userSign]) {
        self.signLB.text = model.userSign;
    }
    else
    {
        self.signLB.text = @"用户暂无签名";
    }

    if ([model.state integerValue] == 1) {
        [self.addBtn setTitle:@"已添加" forState:(UIControlStateNormal)];
        self.addBtn.frame = CGRectMake(300 * ProportionAdapter, 15 * ProportionAdapter, 60 * ProportionAdapter, 26 * ProportionAdapter);
        self.addBtn.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        self.addBtn.userInteractionEnabled = NO;
    }else{
        [self.addBtn setTitle:@"添加" forState:(UIControlStateNormal)];
        self.addBtn.frame = CGRectMake(300 * ProportionAdapter, 15 * ProportionAdapter, 55 * ProportionAdapter, 26 * ProportionAdapter);
        self.addBtn.backgroundColor = [UIColor colorWithHexString:Bar_Color];
        self.addBtn.userInteractionEnabled =  YES;

    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
