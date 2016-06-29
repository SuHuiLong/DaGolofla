//
//  JGHWithdrawMoneyCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHWithDrawModel;

@interface JGHWithdrawMoneyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *prices;

@property (weak, nonatomic) IBOutlet UILabel *propontLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pricesTop;


- (void)configJGHWithDrawModelWithMonay:(JGHWithDrawModel *)model;

- (void)configJGHWithDrawModelWithMonay:(NSNumber *)monay andTradeCatory:(NSInteger)tradeCatory;

@end
