//
//  VipCardOrderDetailTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/4/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardOrderDetailTableViewCell.h"

@implementation VipCardOrderDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

/**
 创建界面
 */
-(void)createUI{
    //标题
    self.titleLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, kWvertical(90), kHvertical(23)) textColor:RGB(160,160,160) fontSize:kHorizontal(15) Title:nil];
    [self.titleLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.titleLabel];
    //描述
    self.descLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(90), 0, screenWidth - kWvertical(100), self.size.height) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    [self.descLabel setNumberOfLines:0];
    [self.contentView addSubview:self.descLabel];
}
//配置数据
-(void)configModel:(VipCardOrderDetailModel *)model{
    //状态，1：红色标题；2：权益明细
    NSInteger status = model.status;
    NSString *titleAddStr = @"：";
    if (model.title.length==0) {
        titleAddStr = @"";
    }
    NSString *title = [NSString stringWithFormat:@"%@%@",model.title,titleAddStr];
    NSString *content = model.content;
    
    self.titleLabel.text = title;
    self.descLabel.text = content;
    //字号
    NSInteger textFont = 15;
    if (status == 1) {
        self.descLabel.textColor = RGB(252,90,1);
    }else if (status == 2){
        textFont = 14;
        self.descLabel.textColor = RGB(160,160,160);
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:content];
        [contentStr addAttribute:NSForegroundColorAttributeName value:RGB(0,134,73) range:NSMakeRange(7, content.length-7)];
        self.descLabel.attributedText = contentStr;
    }
    CGSize contentSize= [content boundingRectWithSize:CGSizeMake(screenWidth - kWvertical(100), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:kHorizontal(textFont)]} context:nil].size;
    self.descLabel.font = [UIFont systemFontOfSize:kHorizontal(textFont)];
    self.descLabel.height = contentSize.height;
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
