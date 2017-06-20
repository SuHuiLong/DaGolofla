//
//  BookCourtTotalPriceTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/6/19.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCourtTotalPriceTableViewCell : UITableViewCell
//订单总价
@property (nonatomic,strong) UILabel *orderPrice;
//订单总价金额
@property (nonatomic,strong) UILabel *orderPriceLabel;
//红包优惠
@property (nonatomic,strong) UILabel *redPacket;
//红包优惠金额
@property (nonatomic,strong) UILabel *redpacketLabel;
//实付总价
@property (nonatomic,strong) UILabel *totalPrice;
//实付总价金额
@property (nonatomic,strong) UILabel *totalPriceLabel;



@end
