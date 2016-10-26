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
        self.backgroundColor = [UIColor redColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i=0; i<4; i++) {
            _recomStadiumView = [[JGHRecomStadiumView alloc]init];
            if (i%2 == 0) {
                _recomStadiumView.frame = CGRectMake(8*ProportionAdapter, (i/2 +1)*8*ProportionAdapter + (i/2)*163*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 163 *ProportionAdapter);
            }else{
                _recomStadiumView.frame = CGRectMake(16*ProportionAdapter +(screenWidth-16*ProportionAdapter)/2, (i/2 +1)*8*ProportionAdapter + (i/2)*163*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 163*ProportionAdapter);
            }
            
            NSLog(@"%d", i/2);
            [self addSubview:_recomStadiumView];
        }
    }
    return self;
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
