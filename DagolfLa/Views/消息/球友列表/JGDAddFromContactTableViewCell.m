//
//  JGDAddFromContactTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 17/3/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDAddFromContactTableViewCell.h"

@implementation JGDAddFromContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLB = [Helper lableRect:CGRectMake(15 * ProportionAdapter, 0, 90 * ProportionAdapter, 51 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:17 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.nameLB];
        
        self.mobileLB = [Helper lableRect:CGRectMake(123 * ProportionAdapter, 0, 150 * ProportionAdapter, 51 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:17 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.mobileLB];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(295 * ProportionAdapter, 13 * ProportionAdapter, 51 * ProportionAdapter, 26 * ProportionAdapter)];
        self.button.layer.cornerRadius = 3 * ProportionAdapter;
        self.button.clipsToBounds = YES;
        self.button.titleLabel.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
        [self.contentView addSubview:self.button];
        
        UILabel *lineLB = [Helper lableRect:CGRectMake(15 * ProportionAdapter, 50.5 * ProportionAdapter, screenWidth - 15 * ProportionAdapter, 0.5 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:1 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:lineLB];
        
    }
    return self;
}

- (void)setState:(NSInteger)state{
    
    if (state) {
        [self.button setTitle:@"添加" forState:(UIControlStateNormal)];
        [self.button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.button.layer.borderWidth = 0;
        [self.button setBackgroundColor:[UIColor colorWithHexString:@"#32B14D"]];
    }else{
        [self.button setTitle:@"邀请" forState:(UIControlStateNormal)];
        [self.button setTitleColor:[UIColor colorWithHexString:@"#F39800"] forState:(UIControlStateNormal)];
        self.button.layer.borderColor = [UIColor colorWithHexString:@"#F39800"].CGColor;
        self.button.layer.borderWidth = 1 * ProportionAdapter;
        [self.button setBackgroundColor:[UIColor whiteColor]];

    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
