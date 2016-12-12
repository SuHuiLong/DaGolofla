//
//  JGLActiveChooseSTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActiveChooseSTableViewCell.h"
#import "JGLAddActiivePlayModel.h"

@implementation JGLActiveChooseSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        [self addSubview:_labelTitle];
        
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 60*ScreenWidth/375, 0, 40*ScreenWidth/375, 40*ScreenWidth/375)];
        [_deleteBtn setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deletePalyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)configJGLAddActiivePlayModel:(JGLAddActiivePlayModel *)model{
    _labelTitle.font = [UIFont systemFontOfSize:14*screenWidth/375];
    
    if ([model.userKey integerValue] == [DEFAULF_USERID integerValue]) {
        _deleteBtn.hidden = YES;
    }else{
        _deleteBtn.hidden = NO;
    }
    
    _labelTitle.font = [UIFont systemFontOfSize:12*ProportionAdapter];
    _labelTitle.textColor = [UIColor colorWithHexString:@"#313131"];
    
    if (![Helper isBlankString:model.name]) {
        _labelTitle.text = [NSString stringWithFormat:@"    %@", model.name];
    }else{
        
        _labelTitle.text = @"    请添加打球人";
    }
}

- (void)deletePalyBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteActivityScorePlayrBtn:)]) {
        [self.delegate deleteActivityScorePlayrBtn:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
