
//
//  BookCourtTotalPriceTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/6/19.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BookCourtTotalPriceTableViewCell.h"

@implementation BookCourtTotalPriceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
#pragma mark - CreateView
-(void)createUI{
    UILabel *testLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, 0, 0) fontSize:kHorizontal(16) Title:@"："];
    [testLabel sizeToFit];
    CGFloat difference = testLabel.width;
    
    UIView *backWhiteView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(120))];
    [self.contentView addSubview:backWhiteView];
    //灰色背景
    UIView *grayView = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, 0, screenWidth, kHvertical(10))];
    [backWhiteView addSubview:grayView];
    //订单总价
    _orderPrice = [Factory createLabelWithFrame:CGRectMake(kWvertical(5), kHvertical(10), kWvertical(90)-difference, kHvertical(36)) textColor:RGB(160,160,160) fontSize:kHorizontal(15) Title:@"订单总价"];
    [_orderPrice setTextAlignment:NSTextAlignmentRight];
    [backWhiteView addSubview:_orderPrice];
    //订单总价金额
    _orderPriceLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(10), screenWidth - kWvertical(10), kHvertical(36)) textColor:RGB(160,160,160) fontSize:kHorizontal(15) Title:@""];
    [_orderPriceLabel setTextAlignment:NSTextAlignmentRight];
    [backWhiteView addSubview:_orderPriceLabel];
    //红包优惠
    _redPacket = [Factory createLabelWithFrame:CGRectMake(kWvertical(5), kHvertical(35), kWvertical(90)-difference, kHvertical(36)) textColor:RGB(160,160,160) fontSize:kHorizontal(15) Title:@"红包优惠"];
    [_redPacket setTextAlignment:NSTextAlignmentRight];
    [backWhiteView addSubview:_redPacket];
    //红包优惠金额
    _redpacketLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(35), screenWidth - kWvertical(10), _orderPriceLabel.height) textColor:RGB(160, 160, 160) fontSize:kHorizontal(15) Title:@""];
    [_redpacketLabel setTextAlignment:NSTextAlignmentRight];
    [backWhiteView addSubview:_redpacketLabel];
    //分割线
    UIImageView *lineView = [Factory createImageViewWithFrame:CGRectMake(0, kHvertical(65), screenWidth, kHvertical(5)) Image:[UIImage imageNamed:@"order_line"]];
    [backWhiteView addSubview:lineView];
    //实付总价
    _totalPrice = [Factory createLabelWithFrame:CGRectMake(kWvertical(5), kHvertical(70), kWvertical(90)-difference, kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(18) Title:@"实付金额"];
    [_totalPrice setTextAlignment:NSTextAlignmentRight];
    [backWhiteView addSubview:_totalPrice];
    //实付总价金额
    _totalPriceLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(70), screenWidth - kWvertical(10), kHvertical(50)) textColor:RGB(252,90,1) fontSize:kHorizontal(16) Title:@""];
    [_totalPriceLabel setTextAlignment:NSTextAlignmentRight];
    [backWhiteView addSubview:_totalPriceLabel];
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
