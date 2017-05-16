//
//  JGHApplyerHeaderCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHApplyerHeaderCell : UITableViewCell

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UILabel *line;


- (void)configHeaderName:(NSString *)name;

@end
