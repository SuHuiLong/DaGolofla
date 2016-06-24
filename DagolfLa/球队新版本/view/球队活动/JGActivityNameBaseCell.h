//
//  JGActivityNameBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGActivityNameBaseCell : UITableViewCell
//base
@property (weak, nonatomic) IBOutlet UILabel *baseLabel;

- (void)configCostSubInstructionPriceFloat:(CGFloat)price;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topValue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downValue;

- (void)configActivityRefundRulesString:(NSString *)string;


@end
