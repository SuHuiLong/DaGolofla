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

- (void)configJGHShowSuppliesMallTableViewCell:(NSArray *)array{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<array.count; i++) {
        
        if (i%2 == 0) {
            _suppliesMallView = [[JGHSuppliesMallView alloc]initWithFrame:CGRectMake(8*ProportionAdapter, (i/2 +1)*8*ProportionAdapter + (i/2)*155*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 155 *ProportionAdapter)];
        }else{
            _suppliesMallView = [[JGHSuppliesMallView alloc]initWithFrame:CGRectMake(16*ProportionAdapter +(screenWidth-16*ProportionAdapter)/2, (i/2 +1)*8*ProportionAdapter + (i/2)*155*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 155 *ProportionAdapter)];
        }
        
        [_suppliesMallView configJGHSuppliesMallView:array[i]];
        [self addSubview:_suppliesMallView];
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
