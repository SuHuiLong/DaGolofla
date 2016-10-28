//
//  JGHShowRecomStadiumTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowRecomStadiumTableViewCell.h"
#import "JGHRecomStadiumView.h"

@interface JGHShowRecomStadiumTableViewCell ()
{
    JGHRecomStadiumView *_recomStadiumView;
}

@end

@implementation JGHShowRecomStadiumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configJGHShowRecomStadiumTableViewCell:(NSArray *)array{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<array.count; i++) {
        if (i%2 == 0) {
            _recomStadiumView = [[JGHRecomStadiumView alloc]initWithFrame:CGRectMake(8*ProportionAdapter, (i/2 +1)*8*ProportionAdapter + (i/2)*163*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 163 *ProportionAdapter)];
        }else{
            _recomStadiumView = [[JGHRecomStadiumView alloc]initWithFrame:CGRectMake(16*ProportionAdapter +(screenWidth-16*ProportionAdapter)/2, (i/2 +1)*8*ProportionAdapter + (i/2)*163*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 163*ProportionAdapter)];
        }
        
        [_recomStadiumView configJGHRecomStadiumView:array[i]];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        selectBtn.tag = 400 +i;
        [selectBtn addTarget:self action:@selector(recomStadiumClick:) forControlEvents:UIControlEventTouchUpInside];
        [_recomStadiumView addSubview:selectBtn];
        [self addSubview:_recomStadiumView];
    }
}

- (void)recomStadiumClick:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(recomStadiumSelectClick:)]) {
        [self.delegate recomStadiumSelectClick:btn];
    }
    
    btn.enabled = YES;
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
