//
//  JGHActivityInfoCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHActivityInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLableLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLableTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLableRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLableDown;

@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@end
