//
//  JGHTimeViewListCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/3.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHTimeViewListCell : UITableViewCell

@property (nonatomic, retain)UILabel *timeLable;

@property (nonatomic, retain)UILabel *priceLable;

@property (nonatomic, retain)UILabel *line;


- (void)configJGHTimeViewListCell:(NSDictionary *)pircedict;

@end
