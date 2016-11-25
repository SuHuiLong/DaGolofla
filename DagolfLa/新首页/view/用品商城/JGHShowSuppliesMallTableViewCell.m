//
//  JGHShowSuppliesMallTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowSuppliesMallTableViewCell.h"
#import "JGHSuppliesMallView.h"

@interface JGHShowSuppliesMallTableViewCell ()
{
    JGHSuppliesMallView *_suppliesMallView;
}

@end

@implementation JGHShowSuppliesMallTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)configJGHShowSuppliesMallTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<array.count; i++) {
        if (i%2 == 0) {
            _suppliesMallView = [[JGHSuppliesMallView alloc]initWithFrame:CGRectMake(8*ProportionAdapter, (i/2 +1)*8*ProportionAdapter + (i/2)*(104 +imageW)*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, (104 +imageH) *ProportionAdapter)];
        }else{
            _suppliesMallView = [[JGHSuppliesMallView alloc]initWithFrame:CGRectMake(12*ProportionAdapter +(screenWidth-24*ProportionAdapter)/2, (i/2 +1)*8*ProportionAdapter + (i/2)*(104 +imageW)*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, (104 +imageH) *ProportionAdapter)];
        }
        
        [_suppliesMallView configJGHSuppliesMallView:array[i] andImageW:imageW andImageH:imageH];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (screenWidth-24*ProportionAdapter)/2, (104 +imageW) *ProportionAdapter)];
        selectBtn.tag = 500 +i;
        [selectBtn addTarget:self action:@selector(suppliesMallClick:) forControlEvents:UIControlEventTouchUpInside];
        [_suppliesMallView addSubview:selectBtn];
        [self addSubview:_suppliesMallView];
    }
}

- (void)suppliesMallClick:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(suppliesMallSelectClick:)]) {
        [self.delegate suppliesMallSelectClick:btn];
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
