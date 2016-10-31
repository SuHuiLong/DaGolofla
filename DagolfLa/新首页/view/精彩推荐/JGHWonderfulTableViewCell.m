//
//  JGHWonderfulTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWonderfulTableViewCell.h"
#import "JGHWonderfulView.h"

@interface JGHWonderfulTableViewCell ()
{
    JGHWonderfulView *_wonderfulView;
}

@end

@implementation JGHWonderfulTableViewCell

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
