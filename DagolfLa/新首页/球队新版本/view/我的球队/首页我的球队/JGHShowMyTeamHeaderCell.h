//
//  JGHShowMyTeamHeaderCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JGHShowMyTeamHeaderCell : UITableViewCell


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLbaleH;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLableLeft;//10

@property (weak, nonatomic) IBOutlet UILabel *name;//18
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//10


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineRight;


- (void)configJGHShowMyTeamHeaderCell:(NSString *)name andSection:(NSInteger)section;

@end
