//
//  JGLFinishBtnTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLFinishBtnTableViewCell.h"
#import "UITool.h"
@implementation JGLFinishBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _btnFInish = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFInish setTitle:@"立即添加" forState:UIControlStateNormal];
        [_btnFInish setTitleColor:[UITool colorWithHexString:@"32b14d" alpha:1] forState:UIControlStateNormal];
        _btnFInish.titleLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
        _btnFInish.frame = CGRectMake(0, 0, screenWidth, 50*ProportionAdapter);
        [self.contentView addSubview:_btnFInish];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
