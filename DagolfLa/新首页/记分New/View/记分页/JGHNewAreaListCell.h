//
//  JGHNewAreaListCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHNewAreaListCell : UITableViewCell

@property (nonatomic, retain)UILabel *line;

@property (nonatomic, retain)UILabel *tilte;

- (void)configJGHNewAreaListCell:(NSString *)are;

@end
