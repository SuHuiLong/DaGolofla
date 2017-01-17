//
//  JGHNewCancelApplyCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewCancelApplyCell.h"

@implementation JGHNewCancelApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _name = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth/2 -10*ProportionAdapter, self.frame.size.height)];
        _name.font = [UIFont systemFontOfSize:16*ProportionAdapter];
        _name.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_name];
        
        _mobile = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2 -10*ProportionAdapter, self.frame.size.height)];
        _mobile.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _mobile.textAlignment = NSTextAlignmentRight;
        [self addSubview:_mobile];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configDict:(NSMutableDictionary *)dict{
    if ([dict objectForKey:@"name"]) {
        self.name.text = [NSString stringWithFormat:@"报名人：%@", [dict objectForKey:@"name"]];
    }
    
    if ([dict objectForKey:@"mobile"]) {
        self.mobile.text = [dict objectForKey:@"mobile"];
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
