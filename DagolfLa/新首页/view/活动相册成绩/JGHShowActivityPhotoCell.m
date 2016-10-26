//
//  JGHShowActivityPhotoCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowActivityPhotoCell.h"
#import "JGHShowActivityView.h"

@interface JGHShowActivityPhotoCell ()
{
    JGHShowActivityView *_showActivityView;
}

@end

@implementation JGHShowActivityPhotoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor redColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)configJGHShowActivityPhotoCell:(NSArray *)activtiyList{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<activtiyList.count; i++) {
        
        _showActivityView = [[JGHShowActivityView alloc]initWithFrame:CGRectMake(14 *ProportionAdapter, 60 *i *ProportionAdapter +(i+1)*10 *ProportionAdapter, screenWidth -28*ProportionAdapter, 60 *ProportionAdapter)];
        _showActivityView.backgroundColor = [UIColor whiteColor];
        [_showActivityView configJGHShowActivityView:activtiyList[i]];
        [self addSubview:_showActivityView];
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
