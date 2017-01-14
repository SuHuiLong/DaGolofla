//
//  JGHActivityAllCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHActivityAllCell.h"

@implementation JGHActivityAllCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 11 *ProportionAdapter, 22 *ProportionAdapter, 22 *ProportionAdapter)];
        [self addSubview:_headerImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 10 *ProportionAdapter, screenWidth - 50*ProportionAdapter, 24 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_name];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configImageName:(NSString *)imageName withName:(NSString *)name{
    _headerImageView.image = [UIImage imageNamed:imageName];
    
    _name.text = name;
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
