//
//  JGHTextFiledCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHTextFiledCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titles;

@property (weak, nonatomic) IBOutlet UITextField *titlefileds;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titlefiledsRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;


- (void)configViewTitles;

- (void)configViewWithDraw:(NSNumber *)monay;

- (void)configPayPassword;

@end
