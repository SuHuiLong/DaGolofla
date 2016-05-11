//
//  JGCostsDescriptionCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGCostsDescriptionCell : UITableViewCell
//人均车费
@property (weak, nonatomic) IBOutlet UILabel *perCost;
//场地费用
@property (weak, nonatomic) IBOutlet UILabel *arddessCost;
//其他
@property (weak, nonatomic) IBOutlet UILabel *others;
//合集人均总费用
@property (weak, nonatomic) IBOutlet UILabel *totalPerCost;
@end
