//
//  JGHCostListCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHCostListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;

@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueTextFieldRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueTextFieldW;

- (void)configCostListCell:(NSMutableDictionary *)dict;

@end
