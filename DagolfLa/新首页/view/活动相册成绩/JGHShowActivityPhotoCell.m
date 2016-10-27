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
        self.backgroundColor = [UIColor whiteColor];
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
        
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        selectBtn.tag = 200 +i;
        [selectBtn addTarget:self action:@selector(activityClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showActivityView addSubview:selectBtn];
        [self addSubview:_showActivityView];
    }
}

- (void)activityClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(activityListSelectClick:)]) {
        [self.delegate activityListSelectClick:btn];
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
