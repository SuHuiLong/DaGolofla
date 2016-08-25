//
//  JGHApplyCatoryPriceViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHApplyCatoryPriceViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *catoryLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *catoryLableLeft;//40

@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLableRight;//50

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnRight;//30


@end
