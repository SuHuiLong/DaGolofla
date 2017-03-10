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
#import "JGHSpectatorSportsView.h"
#import "JGHGolfPackageView.h"

@interface JGHIndexTableViewCell ()<JGHSpectatorSportsViewDelegate, JGHGolfPackageViewDelegate>

{
    JGHWonderfulView *_wonderfulView;
    JGHRecomStadiumView *_recomStadiumView;
    JGHSuppliesMallView *_suppliesMallView;
    JGDHotTeamView *_hotTeamView;
    JGHSpectatorSportsView *_spectatorSportsView;
    JGHGolfPackageView *_golfPackageView;
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
//高旅套餐
- (void)configJGHGolfPackageView:(NSArray *)spectatorArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    self.backgroundColor = [UIColor whiteColor];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _golfPackageView = [[JGHGolfPackageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, imageH +99*ProportionAdapter)];
    _golfPackageView.delegate = self;
    [_golfPackageView configJGHGolfPackageViewData:spectatorArray andImageW:imageW andImageH:imageH];
    [self addSubview:_golfPackageView];
}
#pragma mark -- 高旅套餐
- (void)didSelectGolgPackageViewUrlString:(NSInteger)selectID{
    if ([self.delegate respondsToSelector:@selector(didSelectGolgPackageUrlString:)]) {
        [self.delegate didSelectGolgPackageUrlString:selectID];
    }
}
//精彩赛事
- (void)configJGHSpectatorSportsView:(NSArray *)spectatorArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    self.backgroundColor = [UIColor whiteColor];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _spectatorSportsView = [[JGHSpectatorSportsView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, imageH +99*ProportionAdapter)];
    _spectatorSportsView.delegate = self;
    [_spectatorSportsView configJGHSpectatorSportsViewData:spectatorArray andImageW:imageW andImageH:imageH];
    [self addSubview:_spectatorSportsView];
}
#pragma mark -- 精彩赛事
- (void)selectSpectatorSportsViewUrlString:(NSInteger)selectID{
    if ([self.delegate respondsToSelector:@selector(selectSpectatorSportsUrlString:)]) {
        [self.delegate selectSpectatorSportsUrlString:selectID];
    }
}
- (void)configJGHWonderfulTableViewCell:(NSArray *)wonderfulArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    self.backgroundColor = [UIColor whiteColor];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i=0; i<wonderfulArray.count; i++) {
        
        if (i%2 == 0) {
            _wonderfulView = [[JGHWonderfulView alloc]initWithFrame:CGRectMake(8*ProportionAdapter, (i/2 )*8*ProportionAdapter + (i/2)*(imageH +35)*ProportionAdapter, screenWidth/2 -12*ProportionAdapter, (imageH +35) *ProportionAdapter)];
        }else{
            _wonderfulView = [[JGHWonderfulView alloc]initWithFrame:CGRectMake( screenWidth/2 +4*ProportionAdapter, (i/2 )*8*ProportionAdapter + (i/2)*(imageH +35)*ProportionAdapter, screenWidth/2 -12*ProportionAdapter, (imageH +35) *ProportionAdapter)];
        }
        
        NSLog(@"%d", i/2);
        _wonderfulView.backgroundColor = [UIColor whiteColor];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _wonderfulView.frame.size.width, (imageH +35) *ProportionAdapter)];
        selectBtn.tag = 300 +i;
        [selectBtn addTarget:self action:@selector(wonderfulClick:) forControlEvents:UIControlEventTouchUpInside];
        [_wonderfulView addSubview:selectBtn];
        
        [_wonderfulView configJGHWonderfulView:wonderfulArray[i] andImageW:imageW andImageH:imageH];
        [self addSubview:_wonderfulView];
    }
}
- (void)configJGHShowRecomStadiumTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    self.backgroundColor = [UIColor whiteColor];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<array.count; i++) {
        if (i%2 == 0) {
            _recomStadiumView = [[JGHRecomStadiumView alloc]initWithFrame:CGRectMake(8*ProportionAdapter, (i/2)*8*ProportionAdapter + (i/2)*(imageH +56)*ProportionAdapter, screenWidth/2 -12*ProportionAdapter, (imageH +56) *ProportionAdapter)];
        }else{
            _recomStadiumView = [[JGHRecomStadiumView alloc]initWithFrame:CGRectMake(screenWidth/2 +4*ProportionAdapter, (i/2)*8*ProportionAdapter + (i/2)*(imageH +56)*ProportionAdapter, screenWidth/2 -12*ProportionAdapter, (imageH +56)*ProportionAdapter)];
        }
        
        [_recomStadiumView configJGHRecomStadiumView:array[i] andImageW:imageW andImageH:imageH];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _recomStadiumView.frame.size.width, (imageH +56)*ProportionAdapter)];
        selectBtn.tag = 400 +i;
        [selectBtn addTarget:self action:@selector(recomStadiumClick:) forControlEvents:UIControlEventTouchUpInside];
        [_recomStadiumView addSubview:selectBtn];
        [self addSubview:_recomStadiumView];
    }
}

- (void)configJGHShowSuppliesMallTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<array.count; i++) {
        if (i%2 == 0) {
            _suppliesMallView = [[JGHSuppliesMallView alloc]initWithFrame:CGRectMake(0, (i/2)*4*ProportionAdapter + (i/2)*(104 +imageW)*ProportionAdapter, screenWidth/2 -2*ProportionAdapter, (104 +imageH) *ProportionAdapter)];
        }else{
            _suppliesMallView = [[JGHSuppliesMallView alloc]initWithFrame:CGRectMake(screenWidth/2 +2*ProportionAdapter, (i/2)*4*ProportionAdapter + (i/2)*(104 +imageW)*ProportionAdapter, screenWidth/2 -2*ProportionAdapter, (104 +imageH) *ProportionAdapter)];
        }
        
        if (i == 0) {
            UILabel *topLine = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 0, _suppliesMallView.frame.size.width -10 *ProportionAdapter, 0.5)];
            topLine.backgroundColor = [UIColor colorWithHexString:BG_color];
            [_suppliesMallView addSubview:topLine];
        }
        
        if (i == 1) {
            UILabel *topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _suppliesMallView.frame.size.width -10 *ProportionAdapter, 0.5)];
            topLine.backgroundColor = [UIColor colorWithHexString:BG_color];
            [_suppliesMallView addSubview:topLine];
        }
        
        [_suppliesMallView configJGHSuppliesMallView:array[i] andImageW:imageW andImageH:imageH];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _suppliesMallView.frame.size.width, (104 +imageW) *ProportionAdapter)];
        selectBtn.tag = 500 +i;
        [selectBtn addTarget:self action:@selector(suppliesMallClick:) forControlEvents:UIControlEventTouchUpInside];
        [_suppliesMallView addSubview:selectBtn];
        [self addSubview:_suppliesMallView];
    }
}

- (void)configJGDHotTeamCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.backgroundColor = [UIColor whiteColor];
    for (int i=0; i<array.count; i++) {
        _hotTeamView = [[JGDHotTeamView alloc]initWithFrame:CGRectMake(0, i*(imageH +25)*ProportionAdapter, screenWidth, (imageH +25) *ProportionAdapter)];
        [_hotTeamView configJGHShowFavouritesCell:array[i] andImageW:imageW andImageH:imageH];
        
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _hotTeamView.frame.size.width, (imageH +25) *ProportionAdapter)];
        selectBtn.tag = 600 +i;
        [selectBtn addTarget:self action:@selector(hotTeamClick:) forControlEvents:UIControlEventTouchUpInside];
        [_hotTeamView addSubview:selectBtn];
        
        if (i < array.count -1) {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, _hotTeamView.frame.size.height -1, screenWidth - 20 *ProportionAdapter, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#F0F1F2"];
            [_hotTeamView addSubview:line];
        }
        
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
