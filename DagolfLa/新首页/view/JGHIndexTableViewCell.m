//
//  JGHIndexTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHIndexTableViewCell.h"
#import "JGHWonderfulView.h"
#import "JGHRecomStadiumView.h"
#import "JGHSuppliesMallView.h"
#import "JGDHotTeamView.h"

@interface JGHIndexTableViewCell ()

{
    JGHWonderfulView *_wonderfulView;
    JGHRecomStadiumView *_recomStadiumView;
    JGHSuppliesMallView *_suppliesMallView;
    JGDHotTeamView *_hotTeamView;
}

@end

@implementation JGHIndexTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)configJGHWonderfulTableViewCell:(NSArray *)wonderfulArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i=0; i<wonderfulArray.count; i++) {
        
        if (i%2 == 0) {
            _wonderfulView = [[JGHWonderfulView alloc]initWithFrame:CGRectMake(8*ProportionAdapter, (i/2 +1)*8*ProportionAdapter + (i/2)*(imageH +35)*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, (imageH +35) *ProportionAdapter)];
        }else{
            _wonderfulView = [[JGHWonderfulView alloc]initWithFrame:CGRectMake(16*ProportionAdapter +(screenWidth-16*ProportionAdapter)/2, (i/2 +1)*8*ProportionAdapter + (i/2)*(imageH +35)*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, (imageH +35) *ProportionAdapter)];
        }
        
        NSLog(@"%d", i/2);
        _wonderfulView.backgroundColor = [UIColor whiteColor];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth -16*ProportionAdapter, (imageH +35) *ProportionAdapter)];
        selectBtn.tag = 300 +i;
        [selectBtn addTarget:self action:@selector(wonderfulClick:) forControlEvents:UIControlEventTouchUpInside];
        [_wonderfulView addSubview:selectBtn];
        
        [_wonderfulView configJGHWonderfulView:wonderfulArray[i] andImageW:imageW andImageH:imageH];
        [self addSubview:_wonderfulView];
    }
}
- (void)configJGHShowRecomStadiumTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<array.count; i++) {
        if (i%2 == 0) {
            _recomStadiumView = [[JGHRecomStadiumView alloc]initWithFrame:CGRectMake(8*ProportionAdapter, (i/2 +1)*8*ProportionAdapter + (i/2)*(imageH +56)*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, (imageH +56) *ProportionAdapter)];
        }else{
            _recomStadiumView = [[JGHRecomStadiumView alloc]initWithFrame:CGRectMake(16*ProportionAdapter +(screenWidth-16*ProportionAdapter)/2, (i/2 +1)*8*ProportionAdapter + (i/2)*(imageH +56)*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, (imageH +56)*ProportionAdapter)];
        }
        
        [_recomStadiumView configJGHRecomStadiumView:array[i] andImageW:imageW andImageH:imageH];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth - 16*ProportionAdapter, (imageH +56)*ProportionAdapter)];
        selectBtn.tag = 400 +i;
        [selectBtn addTarget:self action:@selector(recomStadiumClick:) forControlEvents:UIControlEventTouchUpInside];
        [_recomStadiumView addSubview:selectBtn];
        [self addSubview:_recomStadiumView];
    }
}

- (void)configJGHShowSuppliesMallTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<array.count; i++) {
        if (i%2 == 0) {
            _suppliesMallView = [[JGHSuppliesMallView alloc]initWithFrame:CGRectMake(8*ProportionAdapter, (i/2 +1)*8*ProportionAdapter + (i/2)*(104 +imageW)*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, (104 +imageH) *ProportionAdapter)];
        }else{
            _suppliesMallView = [[JGHSuppliesMallView alloc]initWithFrame:CGRectMake(16*ProportionAdapter +(screenWidth-16*ProportionAdapter)/2, (i/2 +1)*8*ProportionAdapter + (i/2)*(104 +imageW)*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, (104 +imageH) *ProportionAdapter)];
        }
        
        [_suppliesMallView configJGHSuppliesMallView:array[i] andImageW:imageW andImageH:imageH];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, (104 +imageW) *ProportionAdapter)];
        selectBtn.tag = 500 +i;
        [selectBtn addTarget:self action:@selector(suppliesMallClick:) forControlEvents:UIControlEventTouchUpInside];
        [_suppliesMallView addSubview:selectBtn];
        [self addSubview:_suppliesMallView];
    }
}

- (void)configJGDHotTeamCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    for (int i=0; i<array.count; i++) {
        _hotTeamView = [[JGDHotTeamView alloc]initWithFrame:CGRectMake(0, i*90*ProportionAdapter, screenWidth, 90 *ProportionAdapter)];
        [_hotTeamView configJGHShowFavouritesCell:array[i]];
        
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 90 *ProportionAdapter)];
        selectBtn.tag = 600 +i;
        [selectBtn addTarget:self action:@selector(hotTeamClick:) forControlEvents:UIControlEventTouchUpInside];
        [_suppliesMallView addSubview:selectBtn];
        [self addSubview:_hotTeamView];
    }
    
}

- (void)hotTeamClick:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(hotTeamSelectClick:)]) {
        [self.delegate hotTeamSelectClick:btn];
    }
    
    btn.enabled = YES;
}

- (void)suppliesMallClick:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(suppliesMallSelectClick:)]) {
        [self.delegate suppliesMallSelectClick:btn];
    }
    
    btn.enabled = YES;
}

- (void)recomStadiumClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(recomStadiumSelectClick:)]) {
        [self.delegate recomStadiumSelectClick:btn];
    }
    
}

- (void)wonderfulClick:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(wonderfulSelectClick:)]) {
        [self.delegate wonderfulSelectClick:btn];
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
