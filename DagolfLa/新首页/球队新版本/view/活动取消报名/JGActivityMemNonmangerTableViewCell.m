//
//  JGActivityMemNonmangerTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGActivityMemNonmangerTableViewCell.h"

@implementation JGActivityMemNonmangerTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
#pragma mark - CreateView
-(void)createView{
    //头像
    _headIconV = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(5), kHvertical(40), kHvertical(40)) Image:nil];
    [self.contentView addSubview:_headIconV];
    //昵称
    _nameLB = [Factory createLabelWithFrame:CGRectMake(_headIconV.x_width + kWvertical(5), kHvertical(5), kWvertical(78), kHvertical(22)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    [self.contentView addSubview:_nameLB];
    //性别
//    _sexIconV = []
    //差点
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
