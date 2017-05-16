//
//  JGHTotalPriceCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHTotalPriceCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *totalPrice;


- (void)configTotalPrice:(float)total;

@end
