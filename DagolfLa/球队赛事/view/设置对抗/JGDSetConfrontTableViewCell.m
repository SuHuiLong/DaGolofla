//
//  JGDSetConfrontTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/10/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDSetConfrontTableViewCell.h"

@interface JGDSetConfrontTableViewCell ()

@end

@implementation JGDSetConfrontTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *picImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 0, screenWidth - 20 * ProportionAdapter, 35 * ProportionAdapter)];
        picImageV.image = [UIImage imageNamed:@"vs_title"];
        [self.contentView addSubview:picImageV];
        picImageV.userInteractionEnabled = YES;
        
        self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5 * ProportionAdapter, 10 * ProportionAdapter, 130 * ProportionAdapter, 20 * ProportionAdapter)];
        [self.leftButton setTitle:@"+ 打高尔夫啦俱乐部" forState:(UIControlStateNormal)];
//        [self.leftButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.leftButton.titleLabel.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.leftButton.tag = 201;
        [picImageV addSubview:self.leftButton];
        
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(220 * ProportionAdapter, 10 * ProportionAdapter, 130 * ProportionAdapter, 20 * ProportionAdapter)];
        [self.rightButton setTitle:@"+ 打高尔夫啦俱乐部" forState:(UIControlStateNormal)];
        //        [self.leftButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.rightButton.titleLabel.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.rightButton.tag = 202;
        [picImageV addSubview:self.rightButton];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
