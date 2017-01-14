//
//  JGHActivityAllCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHActivityAllCell : UITableViewCell

@property (nonatomic, retain)UIImageView *headerImageView;

@property (nonatomic, retain)UILabel *name;

- (void)configImageName:(NSString *)imageName withName:(NSString *)name;


@end
