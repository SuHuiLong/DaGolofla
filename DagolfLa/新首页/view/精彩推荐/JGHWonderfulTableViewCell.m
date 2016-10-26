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
        self.backgroundColor = [UIColor redColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i=0; i<6; i++) {
            _wonderfulView = [[JGHWonderfulView alloc]init];
            if (i%2 == 0) {
                _wonderfulView.frame = CGRectMake(8*ProportionAdapter, (i/2 +1)*8*ProportionAdapter + (i/2)*135*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 135 *ProportionAdapter);
            }else{
                _wonderfulView.frame = CGRectMake(16*ProportionAdapter +(screenWidth-16*ProportionAdapter)/2, (i/2 +1)*8*ProportionAdapter + (i/2)*135*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 135 *ProportionAdapter);
            }
            
            NSLog(@"%d", i/2);
            _wonderfulView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_wonderfulView];
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
