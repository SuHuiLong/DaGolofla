//
//  VipCardOrderListTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/4/10.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardOrderListTableViewCell.h"

@implementation VipCardOrderListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    
    return self;
}
/**
 创建界面
 */
-(void)createView{
    //背景图
    UIView *whiteView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(200))];
    [self.contentView addSubview:whiteView];
    //下单时间
    self.timeLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, screenWidth-kWvertical(10), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:@"下单时间：2017.03.03 09:18"];
    [whiteView addSubview:self.timeLabel];
    //状态
    self.statusLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, screenWidth-kWvertical(10), kHvertical(50)) textColor:RGB(252,90,1) fontSize:kHorizontal(17) Title:@"已完成"];
    [self.statusLabel setTextAlignment:NSTextAlignmentRight];
    [whiteView addSubview:self.statusLabel];
    //绘制直线
    UIView *headerLine = [Factory createViewWithBackgroundColor:RGB(213,213,213) frame:CGRectMake(0, kHvertical(50), screenWidth, 1)];
    [whiteView addSubview:headerLine];
    //图片
    self.cardImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(71), kWvertical(92), kHvertical(58)) Image:nil];
    _cardImageView.backgroundColor = RandomColor;
    [whiteView addSubview:self.cardImageView];
    //下线
    UIView *bottomLine = [Factory createViewWithBackgroundColor:RGB(213,213,213) frame:CGRectMake(kWvertical(10), self.cardImageView.y_height + kHvertical(21), screenWidth-kWvertical(10), 1)];
    [whiteView addSubview:bottomLine];
    //数量
    self.cardNumLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), bottomLine.y_height, screenWidth-kWvertical(10), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:@"共 2 件商品"];
    [whiteView addSubview:self.cardNumLabel];
    //总计价格
    self.totalPriceLabel = [Factory createLabelWithFrame:CGRectMake(0, self.cardNumLabel.y, screenWidth-kWvertical(10), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    
    
}

/**
 配置数据

 @param model 当前cell的数据
 */
-(void)configModel:(VipCardOrderListModel *)model{

    NSString *totalPrice = @"9300";
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计： ¥%@",totalPrice]];
//    [attributed addAttribute:NSForegroundColorAttributeName value:RGB(252,90,1) range:NSMakeRange(<#NSUInteger loc#>, <#NSUInteger len#>)];
    
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
