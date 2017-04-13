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
    self.contentView.backgroundColor = RGB(238,238,238);
    //背景图
    UIView *whiteView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(200))];
    [self.contentView addSubview:whiteView];
    //下单时间
    self.timeLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, screenWidth-kWvertical(10), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    [whiteView addSubview:self.timeLabel];
    //状态
    self.statusLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, screenWidth-kWvertical(10), kHvertical(50)) textColor:RGB(252,90,1) fontSize:kHorizontal(17) Title:nil];
    [self.statusLabel setTextAlignment:NSTextAlignmentRight];
    [whiteView addSubview:self.statusLabel];
    //绘制直线
    UIView *headerLine = [Factory createViewWithBackgroundColor:RGB(213,213,213) frame:CGRectMake(0, kHvertical(50), screenWidth, 1)];
    [whiteView addSubview:headerLine];
    //图片
    self.cardImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(71), kWvertical(92), kHvertical(58)) Image:nil];
    [whiteView addSubview:self.cardImageView];
    //卡片名
    self.cardNameLabel = [Factory createLabelWithFrame:CGRectMake(self.cardImageView.x_width + kWvertical(11), headerLine.y_height + kHvertical(33), screenWidth - kWvertical(123), kHvertical(14)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    [whiteView addSubview:self.cardNameLabel];
    //单张价格
    self.singlePriceLabel = [Factory createLabelWithFrame:CGRectMake(self.cardNameLabel.x, self.cardNameLabel.y_height + kHvertical(11), self.cardNameLabel.width, kHorizontal(12)) textColor:RGB(252,90,1) fontSize:kHorizontal(12) Title:nil];
    [whiteView addSubview:self.singlePriceLabel];
    //数量1
    self.cardNumLabel1 = [Factory createLabelWithFrame:CGRectMake(self.singlePriceLabel.x, self.singlePriceLabel.y, self.singlePriceLabel.width, kHvertical(12)) textColor:RGB(49,49,49) fontSize:kHorizontal(12) Title:nil];
    [self.cardNumLabel1 setTextAlignment:NSTextAlignmentRight];
    [whiteView addSubview:self.cardNumLabel1];
    //下线
    UIView *bottomLine = [Factory createViewWithBackgroundColor:RGB(213,213,213) frame:CGRectMake(kWvertical(10), self.cardImageView.y_height + kHvertical(21), screenWidth-kWvertical(10), 1)];
    [whiteView addSubview:bottomLine];
    //数量2
    self.cardNumLabel2 = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), bottomLine.y_height, screenWidth-kWvertical(10), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    [whiteView addSubview:self.cardNumLabel2];
    //总计价格
    self.totalPriceLabel = [Factory createLabelWithFrame:CGRectMake(0, self.cardNumLabel2.y, screenWidth-kWvertical(10), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    [self.totalPriceLabel setTextAlignment:NSTextAlignmentRight];
    [whiteView addSubview:self.totalPriceLabel];
    
}

/**
 配置数据

 @param model 当前cell的数据
 */
-(void)configModel:(VipCardOrderListModel *)model{
    //下单时间
    NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",model.createTime];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.timeLabel.text = timeStr;
    //状态
    NSString *statuStr = model.stateShowString;
    self.statusLabel.text = statuStr;
    //卡片
    NSString *picUrl = model.bigPicURL;
    _cardImageView.backgroundColor = RandomColor;
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
    //卡片名
    NSString *nameStr = model.cardName;
    self.cardNameLabel.text = nameStr;
    //单个价格
    NSString *singlePrice = [NSString stringWithFormat:@"￥%@",model.money];
    NSMutableAttributedString *singlePriceStr = [[NSMutableAttributedString alloc] initWithString:singlePrice];
    [singlePriceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(15)] range:NSMakeRange(1, singlePrice.length-1)];
    self.singlePriceLabel.attributedText = singlePriceStr;
    //卡片数
    NSInteger cardNum = model.buyNumber;
    NSString *cardNumStr1 = [NSString stringWithFormat:@"x%ld",cardNum];
    NSString *cardNumStr2 = [NSString stringWithFormat:@"共 %ld 件商品",cardNum];
    self.cardNumLabel1.text = cardNumStr1;
    self.cardNumLabel2.text = cardNumStr2;
    //总价
    NSString *totalPrice = model.totalMoney;
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计： ¥%@",totalPrice]];
    [attributed addAttribute:NSForegroundColorAttributeName value:RGB(252,90,1) range:NSMakeRange(3, attributed.length-3)];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(14)] range:NSMakeRange(4, 1)];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(18)] range:NSMakeRange(5, attributed.length-5)];
    self.totalPriceLabel.attributedText = attributed;
    
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
