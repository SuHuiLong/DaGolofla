//
//  JGHNewCancelApplyCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHNewCancelApplyCell : UITableViewCell

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UILabel *mobile;

@property (nonatomic, retain)UILabel *line;

- (void)configDict:(NSMutableDictionary *)dict;

@end
