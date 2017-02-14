//
//  JGHChancelTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHChancelTableViewCell.h"
#import "JGHIndexEventView.h"

@interface JGHChancelTableViewCell ()
{
    JGHIndexEventView *_indexEventView;
}

@end

@implementation JGHChancelTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)configJGHChancelTableViewCellMatchList:(NSArray *)matchList{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<matchList.count; i++) {
        
        _indexEventView = [[JGHIndexEventView alloc]initWithFrame:CGRectMake(0, 80 *i *ProportionAdapter, screenWidth, 80 *ProportionAdapter)];
        _indexEventView.backgroundColor = [UIColor whiteColor];
        [_indexEventView configJGHIndexEventView:matchList[i]];
        
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 80 *ProportionAdapter)];
        selectBtn.tag = 900 +i;
        //        [selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(matchList:) forControlEvents:UIControlEventTouchUpInside];
        [_indexEventView addSubview:selectBtn];
        [self addSubview:_indexEventView];
    }
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth -90*ProportionAdapter)/2, 250*ProportionAdapter, 90 *ProportionAdapter, 40 *ProportionAdapter)];
    [moreBtn setImage:[UIImage imageNamed:@"icn_morenews"] forState:UIControlStateNormal];
    
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#7f7f7f"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    [self addSubview:moreBtn];
}

#pragma mark -- 查看更多
- (void)matchList:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(didSelectChancelClick:)]) {
        [self.delegate didSelectChancelClick:btn];
    }
}
#pragma mark -- 资讯点击
- (void)moreBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(didSelectChancelMoreClick:)]) {
        [self.delegate didSelectChancelMoreClick:btn];
    }
}

@end
